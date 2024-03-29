#__________________________________________________________
#
# Local Variables Section
#__________________________________________________________

locals {

#  The following are defined as "local" variables (local.<variable>)
# Local variables are typically used for data transformation or to set initial values
# Sensitive information should be stored in variables (var.<variable>) to be passed in
#    var.<variables can be passed in from TFCB, CLI apply parameters and environment variables

  # Intersight Organization Variable
  org_moid = data.intersight_organization_organization.my_org.id
  
#  az_id = "12"     #Set by var input
#           1 is for DC-1    2 is DC-2     DC-3 is 3  other locations TBD (0 is Test)
#           1 is for first az  2 is for second az,  3 is for third az    etc. 
#  Example DC-1 az 2 ID would be:  "12"
#  All Identity Pools for a az will contain the az ID (MAc, WWNN, WWPN, UUID)

#  az_description = "Built by Terraform ${var.az_policy_prefix}"    #Set by var input

  #Every object created in the az main module will have these tags
  az_tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "az", "value" : "${var.az_policy_prefix}" }
  ]

# az VLANS assigned to all FI Switches in the az
# az_vlans = "100,101,200-599,997-999,1200-1250"   # Set by var input

# VNIC QoS policy moids az-Wide
  vnic_qos_besteffort = module.imm_az_qos_mod.vnic_qos_besteffort_moid
  vnic_qos_bronze     = module.imm_az_qos_mod.vnic_qos_bronze_moid
  vnic_qos_silver     = module.imm_az_qos_mod.vnic_qos_silver_moid
  vnic_qos_gold       = module.imm_az_qos_mod.vnic_qos_gold_moid
  # vnic_qos_platinum = module.imm_az_qos_mod.vnic_qos_platinum_moid
  vnic_qos_fc_moid    = module.imm_az_qos_mod.vnic_qos_fc_moid


# This secton create a list of VLAN-Name:VLAN-Number pairs from list of allowed vlans 
  # var.az_vlans      # Example: "2-100,105,110,115 >> {"vlan-2": 2, "vlan-3": 3, ...}"
  # az_vlans = var.az_vlans
  az_vlans = "100,101,200-599,997-999,1200-1250"
  vlan_split = length(regexall("-", local.az_vlans)) > 0 ? tolist(
    split(",", local.az_vlans)
  ) : tolist(local.az_vlans)
  vlan_lists = [for s in local.vlan_split : length(regexall("-", s)) > 0 ? [
    for v in range(
      tonumber(element(split("-", s), 0)),
      (tonumber(element(split("-", s), 1)
    ) + 1)) : tonumber(v)] : [s]
  ]

  # Flatten the list of lists generated above into a single simple list
  flattened_vlan_list = flatten(local.vlan_lists)

  # Convert the list above into a set so it can be used by for_each
  vlan_list_set       = toset(local.flattened_vlan_list)
  # ---------------------------------------------------------------------------

  
}