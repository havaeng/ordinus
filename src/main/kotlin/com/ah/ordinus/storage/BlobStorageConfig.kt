package com.ah.ordinus.storage

import com.azure.storage.blob.BlobServiceClient
import com.azure.storage.blob.BlobServiceClientBuilder
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class BlobStorageConfig {
    @Bean
    fun blobServiceClient(
        @Value("\${spring.cloud.azure.storage.blob.connection-string}") connectionString: String,
    ): BlobServiceClient =
        BlobServiceClientBuilder()
            .connectionString(connectionString)
            .buildClient()
}
