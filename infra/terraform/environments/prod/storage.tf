resource "azurerm_storage_account" "application" {
  name                = var.application_storage_account_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  default_to_oauth_authentication  = true
  https_traffic_only_enabled       = true
  local_user_enabled               = false
  min_tls_version                  = "TLS1_2"
  public_network_access_enabled    = true
  shared_access_key_enabled        = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }

  tags = merge(var.tags, {
    purpose = "application-blob-storage"
  })
}

resource "azurerm_storage_container" "image_submissions" {
  name                  = "image-submissions"
  storage_account_id    = azurerm_storage_account.application.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "published_images" {
  name                  = "published-images"
  storage_account_id    = azurerm_storage_account.application.id
  container_access_type = "private"
}
