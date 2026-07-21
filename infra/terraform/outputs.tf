output "resource_group_name" {
  value = azurerm_resource_group.prod.name
}

output "container_registry_login_server" {
  value = azurerm_container_registry.medalj.login_server
}

output "container_app_url" {
  value = "https://${azurerm_container_app.api.ingress[0].fqdn}"
}

output "postgres_host" {
  value = azurerm_postgresql_flexible_server.medalj.fqdn
}

output "storage_account_name" {
  value = azurerm_storage_account.medalj.name
}
