resource "databricks_notification_destination" "ndresource" {
  display_name = "Example BMC TrueSight Destination"
  config {
    generic_webhook {
      url      = "https://example.host.com/webhook"
      username = "username" // Optional
      password = "password" // Optional
    }
  }
}