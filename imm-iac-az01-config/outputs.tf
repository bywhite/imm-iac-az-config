# Output as needed to reveal Objects created

output "intersight_organization_name" {
  value         = var.organization
  description   = "Default is default, otherwise set in TFCB Variable"
}

output "az_id" {
    value       = var.az_id
    description = "az ID is used in all identifiers: MAC, WWNN, WWPN, UUID"
}

output "az_policy_prefix" {
  value       = var.az_policy_prefix
  description = "Policy prefix for all IMM objects created by this code"
}
