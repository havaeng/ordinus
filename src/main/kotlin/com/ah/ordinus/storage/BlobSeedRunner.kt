package com.ah.ordinus.storage

import com.ah.ordinus.domain.decorationShortCode.DecorationShortCodeRepository
import com.azure.storage.blob.BlobServiceClient
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.ApplicationArguments
import org.springframework.boot.ApplicationRunner
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.context.annotation.Profile
import org.springframework.core.io.support.PathMatchingResourcePatternResolver
import org.springframework.stereotype.Component
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardOpenOption
import java.text.Normalizer
import java.time.OffsetDateTime

@Component
@Profile("local")
@ConditionalOnProperty(
    prefix = "app.blob.seed",
    name = ["enabled"],
    havingValue = "true",
    matchIfMissing = false,
)
class BlobSeedRunner(
    private val blobServiceClient: BlobServiceClient,
    private val decorationShortCodeRepository: DecorationShortCodeRepository,
    @Value("\${app.medals.container-name:medal-pictures}")
    private val containerName: String,
    @Value("\${app.blob.seed.unmatched-log-path:build/blob-seed-unmatched.txt}")
    private val unmatchedLogPath: String,
) : ApplicationRunner {
    private val log = LoggerFactory.getLogger(javaClass)

    override fun run(args: ApplicationArguments) {
        val container = blobServiceClient.getBlobContainerClient(containerName)
        if (!container.exists()) {
            container.create()
            log.info("Created blob container '{}'", containerName)
        }

        val resources = PathMatchingResourcePatternResolver().getResources("classpath:seed/medals/*")

        val unmatchedFiles = mutableListOf<String>()

        resources.forEach { resource ->
            val blobName = resource.filename ?: return@forEach
            val rawShortCode = blobName.substringBeforeLast('.', blobName).trim()
            val shortCode = Normalizer.normalize(rawShortCode, Normalizer.Form.NFC)

            if (shortCode.isBlank()) {
                unmatchedFiles.add(blobName)
                log.warn("Skipping '{}': could not derive short code", blobName)
                return@forEach
            }

            if (!decorationShortCodeRepository.existsByShortCodeIgnoreCase(shortCode)) {
                unmatchedFiles.add(blobName)
                log.info("Skipping '{}': no matching short_code (case-insensitive) for '{}'", blobName, shortCode)
                return@forEach
            }

            val blobClient = container.getBlobClient(blobName)
            if (!blobClient.exists()) {
                resource.inputStream.use { input ->
                    blobClient.upload(input, resource.contentLength(), true)
                }
                log.info("Seeded blob '{}' for short_code='{}'", blobName, shortCode)
            }
        }

        if (unmatchedFiles.isNotEmpty()) {
            log.warn(
                "Blob seed completed with unmatched files ({}): {}",
                unmatchedFiles.size,
                unmatchedFiles.joinToString(", "),
            )
        } else {
            log.info("Blob seed completed. All files matched short codes.")
        }

        persistUnmatched(unmatchedFiles)
        log.info("Blob seed completed. Files scanned: {}, unmatched: {}", resources.size, unmatchedFiles.size)
    }

    private fun persistUnmatched(unmatchedFiles: List<String>) {
        if (unmatchedFiles.isEmpty()) return

        val path = Path.of(unmatchedLogPath)
        path.parent?.let { Files.createDirectories(it) }

        val timestamp = OffsetDateTime.now().toString()
        val lines =
            buildList {
                add("=== $timestamp ===")
                unmatchedFiles.forEach { add(it) }
                add("")
            }

        Files.write(
            path,
            lines,
            StandardCharsets.UTF_8,
            StandardOpenOption.CREATE,
            StandardOpenOption.APPEND,
        )

        log.warn("Persisted {} unmatched blob file names to '{}'", unmatchedFiles.size, path.toAbsolutePath())
    }
}
