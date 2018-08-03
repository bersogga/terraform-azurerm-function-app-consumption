resource "azurerm_storage_account" "funcsta" {
  name                     = "${local.storage_account_name}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "${var.account_replication_type}"
  enable_blob_encryption   = "true"
  enable_file_encryption   = "true"

  tags = "${merge(var.tags, map("environment", var.environment), map("release", var.release))}"
}

resource "azurerm_app_service_plan" "serviceplan" {
  name                = "${local.app_service_plan_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = "${merge(var.tags, map("environment", var.environment), map("release", var.release))}"
}

resource "azurerm_function_app" "functionapp" {
  name                      = "${local.function_app_name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${azurerm_app_service_plan.serviceplan.id}"
  storage_connection_string = "${azurerm_storage_account.funcsta.primary_connection_string}"
  https_only                = true
  version                   = "${var.function_version}"
  client_affinity_enabled   = false

  tags = "${merge(var.tags, map("environment", var.environment), map("release", var.release))}"

  site_config {
    always_on = true
  }

  # MSI not yet supported on Consumption plan?
  # identity {
  #   type = "SystemAssigned"
  # }

  app_settings = "${var.app_settings}"

  lifecycle {
    ignore_changes = ["app_settings"]
  }
}
