output "identity" {
  description = "The MSI identities set on the function app. Returns a list of identities."
  value       = "${azurerm_function_app.functionapp.identity}"
}

