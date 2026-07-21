resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "prod" {
  name     = "rg-medalj-prod"
  location = var.location
}

# ---------------------------------------------------------
# Storage / Blob Storage
# ---------------------------------------------------------

resource "azurerm_storage_account" "medalj" {
  name                     = "stmedalj${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.prod.name
  location                 = azurerm_resource_group.prod.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"
}

resource "azurerm_storage_container" "medal_images" {
  name                  = "medal-images"
  storage_account_id    = azurerm_storage_account.medalj.id
  container_access_type = "private"
}

# ---------------------------------------------------------
# PostgreSQL
# ---------------------------------------------------------

resource "azurerm_postgresql_flexible_server" "medalj" {
  name                = "psql-medalj-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  version = "16"

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  storage_mb = 32768

  sku_name = "B_Standard_B1ms"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
}

resource "azurerm_postgresql_flexible_server_database" "medalj" {
  name      = "medalj"
  server_id = azurerm_postgresql_flexible_server.medalj.id

  collation = "en_US.utf8"
  charset   = "UTF8"
}

# ---------------------------------------------------------
# Azure Container Registry
# ---------------------------------------------------------

resource "azurerm_container_registry" "medalj" {
  name                = "acrmedalj${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

  sku           = "Basic"
  admin_enabled = false
}

# ---------------------------------------------------------
# Container Apps Environment
# ---------------------------------------------------------

resource "azurerm_container_app_environment" "medalj" {
  name                = "cae-medalj-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location
}

# ---------------------------------------------------------
# Container App / Spring Boot backend
# ---------------------------------------------------------

resource "azurerm_container_app" "api" {
  name                         = "ca-medalj-api-prod"
  container_app_environment_id = azurerm_container_app_environment.medalj.id
  resource_group_name          = azurerm_resource_group.prod.name

  revision_mode = "Single"

  identity {
    type = "SystemAssigned"
  }

  registry {
    server   = azurerm_container_registry.medalj.login_server
    identity = "system"
  }

  template {
    min_replicas = 0
    max_replicas = 2

    container {
      name = "medalj-api"

      # Placeholder tills första riktiga image är pushad till ACR.
      image = "mcr.microsoft.com/k8se/quickstart:latest"

      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "SPRING_PROFILES_ACTIVE"
        value = "azure"
      }

      env {
        name  = "DB_HOST"
        value = azurerm_postgresql_flexible_server.medalj.fqdn
      }

      env {
        name  = "DB_NAME"
        value = azurerm_postgresql_flexible_server_database.medalj.name
      }

      env {
        name  = "AZURE_STORAGE_ACCOUNT_NAME"
        value = azurerm_storage_account.medalj.name
      }

      env {
        name  = "AZURE_STORAGE_CONTAINER_NAME"
        value = azurerm_storage_container.medal_images.name
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# ---------------------------------------------------------
# RBAC
# Container App -> Azure Container Registry
# ---------------------------------------------------------

resource "azurerm_role_assignment" "api_acr_pull" {
  scope                = azurerm_container_registry.medalj.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.api.identity[0].principal_id
}

# ---------------------------------------------------------
# RBAC
# Container App -> Blob Storage
# ---------------------------------------------------------

resource "azurerm_role_assignment" "api_blob_access" {
  scope                = azurerm_storage_account.medalj.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_container_app.api.identity[0].principal_id
}
