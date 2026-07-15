package com.ah.ordinus.storage

import com.azure.storage.blob.BlobServiceClient
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.ApplicationArguments
import org.springframework.boot.ApplicationRunner
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.context.annotation.Profile
import org.springframework.core.io.support.PathMatchingResourcePatternResolver
import org.springframework.stereotype.Component

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

        val resources =
            PathMatchingResourcePatternResolver()
                .getResources("classpath:seed/medals/*")

        resources.forEach { resource ->
            val blobName = resource.filename ?: return@forEach
            val blobClient = container.getBlobClient(blobName)
            if (!blobClient.exists()) {
                resource.inputStream.use { input ->
                    blobClient.upload(input, resource.contentLength(), true)
                }
                log.info("Seeded blob '{}'", blobName)
            }
        }

        log.info("Blob seed completed. Files scanned: {}", resources.size)
    }
}
