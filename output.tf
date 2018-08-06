output "identity_principal_id" {
  description = "The MSI identity principal id set on the function app."
  value       = "${azurerm_function_app.functionapp.identity.0.principal_id}"
}

output "identity_tenant_id" {
  description = "The MSI identity tenant id set on the function app."
  value       = "${azurerm_function_app.functionapp.identity.0.tenant_id}"
}