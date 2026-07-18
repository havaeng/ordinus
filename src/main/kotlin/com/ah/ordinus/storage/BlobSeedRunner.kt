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
import java.text.Normalizer

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
) : ApplicationRunner {
    private val log = LoggerFactory.getLogger(javaClass)

    override fun run(args: ApplicationArguments) {
        val container = blobServiceClient.getBlobContainerClient(containerName)
        if (!container.exists()) {
            container.create()
            log.info("Created blob container '{}'", containerName)
        }

        val resources = PathMatchingResourcePatternResolver().getResources("classpath:seed/medals/*")

        val seededFiles = mutableListOf<String>()
        val skippedNoMatch = mutableListOf<String>()
        val skippedAlreadyExists = mutableListOf<String>()

        resources.forEach { resource ->
            val blobName = resource.filename ?: return@forEach
            val rawShortCode = blobName.substringBeforeLast('.', blobName).trim()
            val shortCode = Normalizer.normalize(rawShortCode, Normalizer.Form.NFC)

            val blobClient = container.getBlobClient(blobName)
            when {
                shortCode.isBlank() || !decorationShortCodeRepository.existsByShortCodeIgnoreCase(shortCode) -> {
                    skippedNoMatch.add(blobName)
                    log.info("Skipping '{}': no matching short_code (case-insensitive) for '{}'", blobName, shortCode)
                }

                blobClient.exists() -> {
                    skippedAlreadyExists.add(blobName)
                    log.info("Skipping '{}': already exists in container '{}'", blobName, containerName)
                }

                else -> {
                    resource.inputStream.use { input ->
                        blobClient.upload(input, resource.contentLength(), true)
                    }
                    seededFiles.add(blobName)
                    log.info("Seeded blob '{}' for short_code='{}'", blobName, shortCode)
                }
            }
        }

        log.info("Blob seed completed. Files scanned: {}", resources.size)
        log.info("Successful seed ({}): {}", seededFiles.size, seededFiles.joinToString(", "))
        log.info(
            "Skipped (already exists) ({}): {}",
            skippedAlreadyExists.size,
            skippedAlreadyExists.joinToString(", "),
        )
        log.info("Skipped (no match found) ({}): {}", skippedNoMatch.size, skippedNoMatch.joinToString(", "))
    }
}
