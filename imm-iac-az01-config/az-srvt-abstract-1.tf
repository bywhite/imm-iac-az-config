# # =============================================================================
# # This defines a single Server Profile Template using a remote module
# # Builds: Server Profile Template and associated Server Resource Pool
# #    * Note: Derivation of Server Profiles is outside of TF scope
# # Duplicate this code/file to add another new Server Template and:
# #    * Change module: "server_template_vmwX"  >> "server_template_vmwY"
# #    * Change server_policy_prefix: "...-vmwX" > "...-vmwY"
# #    * Change Tag value for "ServerGroup" to include new name
# #    * Modify parameters as needed to tweak your template configuration
# # -----------------------------------------------------------------------------


module "server_template_abstract_1" {                                   # <<-- Change to duplicate
  source = "github.com/bywhite/imm-iac-az-mods//imm-srvt-abstract-mod"  #?ref=v0.0.1"
            # remote module name above should not be changed when duplicating

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------
  # external sources
  organization    = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # prefix for all created policies
  server_policy_prefix = "${var.az_policy_prefix}-abstract-1"         # <<-- Change to duplicate
  description   = "built by Terraform ${var.az_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "az", "value" : "${var.az_policy_prefix}" },
    { "key" : "ServerGroup", "value" : "${var.az_policy_prefix}-abstract-1" } # <-- Change to duplicate
  ]

# =============================================================================
# X vs B Chassis Profile Customizations
# -----------------------------------------------------------------------------
# Customize policies for X-Series (true) or B-Series (false)
  is_x_series_profile = true 


# =============================================================================
# az-wide pools
# -----------------------------------------------------------------------------

  mac_pool_moid         = module.imm_az_pools_mod.mac_pool_moid
  imc_ip_pool_moid      = module.imm_az_pools_mod.ip_pool_moid
  wwnn_pool_moid        = module.imm_az_pools_mod.wwnn_pool_moid
  wwpn_pool_a_moid      = module.imm_az_pools_mod.wwpn_pool_a_moid
  wwpn_pool_b_moid      = module.imm_az_pools_mod.wwpn_pool_b_moid
  server_uuid_pool_moid = module.imm_az_pools_mod.uuid_pool_moid
  server_uuid_pool_name = module.imm_az_pools_mod.uuid_pool_name


# =============================================================================
# az-wide server policies
# -----------------------------------------------------------------------------

  access_policy     = module.server_policies.access_policy_map["access-1"]
  bios_policy       = module.server_policies.bios_policy_map["bios-1"]
  boot_policy       = module.server_policies.boot_policy_map["boot-1"]
  ipmi_policy       = module.server_policies.ipmi_policy_map["ipmi-1"]
  kvm_policy        = module.server_policies.kvm_policy_map["kvm-1"]
  power_policy      = module.server_policies.power_policy_map["power-3"]
  snmp_policy       = module.server_policies.snmp_policy_map["snmp-1"]
  sol_policy        = module.server_policies.sol_policy_map["sol-1"]
  stor_policy       = module.server_policies.stor_policy_map["stor-2"]
  syslog_policy     = module.server_policies.syslog_policy_map["syslog-1"]
  vmedia_policy     = module.server_policies.vmedia_policy_map["vmedia-1"]

# =============================================================================
# Local IMC Users - defined az wide
# -----------------------------------------------------------------------------
  # Sets local users and their permissions and passwords
  user_policy  = local.iam_user_policy_moid

# =============================================================================
# Server Eth vNic's & FC vHBA's
# -----------------------------------------------------------------------------
# Ensure "pci_order is unique and sequential across all vnic/vhba"
# Ensure vlans & vsans are provisioned on target UCS Domain, use depends_on

  vnic_vlan_sets = {
    "eth0"  = {
      vnic_name  = "eth0"
      native_vlan = 21
      vlan_range  = "21,60,254,255"
      switch_id   = "A"
      pci_order   = 0
      qos_moid    = module.imm_az_qos_mod.vnic_qos_besteffort_moid
      adapter     = module.server_policies.adapter_policy_map["adapter-1"]
      failover    = false
      netgroup    = module.server_policies.netgroup_policy_map["netgroup-1"]
      netcontrol  = module.server_policies.netcontrol_policy_map["netcontrol-1"]
    }
    "eth1"  = {
      vnic_name   = "eth1"
      native_vlan = 21
      vlan_range  = "21,60,254,255"
      switch_id   = "B"
      pci_order   = 1
      qos_moid    = module.imm_az_qos_mod.vnic_qos_besteffort_moid
      adapter     = module.server_policies.adapter_policy_map["adapter-1"]
      failover    = false
      netgroup    = module.server_policies.netgroup_policy_map["netgroup-1"]
      netcontrol  = module.server_policies.netcontrol_policy_map["netcontrol-1"]
    }
  }


  vhba_vsan_sets = {
    "fc0" = {
      vhba_name      = "fc0"
      vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_101_moid
      switch_id      = "A"
      wwpn_pool_moid = module.imm_az_pools_mod.wwpn_pool_a_moid
      pci_order      = 2
      qos_moid       = module.imm_az_qos_mod.vnic_qos_fc_moid
      fcadapter      = module.server_policies.fcadapter_policy_map["fcadapter-1"]
    }
    "fc1"  = {
      vhba_name      = "fc1"
      vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_102_moid
      switch_id      = "B"
      wwpn_pool_moid = module.imm_az_pools_mod.wwpn_pool_b_moid
      pci_order      = 3
      qos_moid       = module.imm_az_qos_mod.vnic_qos_fc_moid
      fcadapter      = module.server_policies.fcadapter_policy_map["fcadapter-1"]
    }
  }

# =============================================================================
# Dependencies
# -----------------------------------------------------------------------------
# The Pools for the az must be created before this domain fabric module executes
  depends_on = [
    module.imm_az_pools_mod, module.imm_az_user_policy_1, module.server_policies,
    module.imm_az_qos_mod, module.imm_az_vsan_policy_1
  ]

}