package com.ah.ordinus.storage

import com.azure.storage.blob.BlobServiceClient
import com.azure.storage.blob.BlobServiceClientBuilder
import com.azure.storage.common.StorageSharedKeyCredential
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class BlobStorageConfig {
    @Bean
    fun blobServiceClient(
        @Value("\${spring.cloud.azure.storage.blob.endpoint}") endpoint: String,
        @Value("\${spring.cloud.azure.storage.blob.account-name}") accountName: String,
        @Value("\${spring.cloud.azure.storage.blob.account-key}") accountKey: String,
    ): BlobServiceClient {
        val credential = StorageSharedKeyCredential(accountName, accountKey)

        return BlobServiceClientBuilder()
            .endpoint(endpoint)
            .credential(credential)
            .buildClient()
    }
}
