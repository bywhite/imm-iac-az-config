# =============================================================================
#  VLAN Related  Policies
#  - AZ Eth Network Policy (VLANs for Switches)
#  - AZ Fabric Multicast Policy for VLANs
#  - AZ Fabric VLAN resources for Eth Network Policy
# -----------------------------------------------------------------------------


# =============================================================================
# Fabric Eth Network (VLAN) Policy
# Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_eth_network_policy
# -----------------------------------------------------------------------------
resource "intersight_fabric_eth_network_policy" "az_fabric_eth_network_policy" {
  name        = "${var.az_policy_prefix}-network-policy"
  description = var.az_description
  organization {
    moid = local.org_moid
  }
  # assign this policy to the domain profile being created by passing its moid


  dynamic "tags" {
    for_each = var.az_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

# =============================================================================
# Multicast
# Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_multicast_policy
# -----------------------------------------------------------------------------

resource "intersight_fabric_multicast_policy" "az_fabric_multicast_policy" {
  name               = "${var.az_policy_prefix}-multicast-policy"
  description        = var.az_description
  querier_ip_address = ""
  querier_state      = "Disabled"
  snooping_state     = "Enabled"
  organization {
    moid        = local.org_moid
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = var.az_tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


# =============================================================================
# Fabric VLANs
# Reference: https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_vlan
# -----------------------------------------------------------------------------
# Associates VLANs with the above policy   extracted from uplink_vlans_6536
# Example results: {"vlan-5": 5, "vlan22": 22, "vlan23: 23, "vlan24":24}
# Provided vlan_list_set must contain at least 1 "-" hyphen in list
resource "intersight_fabric_vlan" "fabric_vlans" {
  for_each              = local.vlan_list_set
  auto_allow_on_uplinks = true
  is_native             = false
  
  name = length(regexall("^[0-9]{4}$", each.value)) > 0 ? join(
    "-", ["az-vlan", each.value]) : length(
    regexall("^[0-9]{3}$", each.value)) > 0 ? join(
    "-", ["az-vlan", each.value]) : length(
    regexall("^[0-9]{2}$", each.value)) > 0 ? join(
    "-", ["az-vlan", each.value]) : join(
  "-", ["az-vlan", each.value])
  
  vlan_id = each.value
  eth_network_policy {
    moid = intersight_fabric_eth_network_policy.az_fabric_eth_network_policy.id
  }
  multicast_policy {
    moid = intersight_fabric_multicast_policy.az_fabric_multicast_policy.moid
  }
}
