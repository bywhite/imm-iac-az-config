# # =============================================================================
# # This defines a single Server Profile Template using a remote module
# # Builds: Server Profile Template and associated Server Resource Pool
# #    * Note: Derivation of Server Profiles is outside of TF scope
# # Duplicate this code/file to add another new Server Template and:
# #    * Change module: "server_template_vmwX"  >> "server_template_vmwY"
# #    * Change server_template_name: "...-vmwX" > "...-vmwY"
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
  server_template_name = "${var.az_policy_prefix}-srvt-vmware-01"         # <<-- Change to duplicate
  description   = "built by Terraform ${var.az_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "az", "value" : "${var.az_policy_prefix}" },
    { "key" : "os-target", "value" : "ESX7-U3" }                          # <-- Change as needed
  ]

# =============================================================================
# Special policy considerations
# -----------------------------------------------------------------------------

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
  stor_policy       = module.server_policies.stor_policy_map["stor-3"]
  syslog_policy     = module.server_policies.syslog_policy_map["syslog-1"]
  vmedia_policy     = module.server_policies.vmedia_policy_map["vmedia-1"]
  lancon_policy     = module.server_policies.lancon_policy_map["lancon-4"]
  sancon_policy     = module.server_policies.sancon_policy_map["sancon-2"]
  
# =============================================================================
# Local IMC Users - defined az wide
# -----------------------------------------------------------------------------
  # Sets local users and their permissions and passwords
  user_policy  = module.imm_az_user_policy_1.iam_user_policy_moid

# =============================================================================
# Dependencies
# -----------------------------------------------------------------------------
# The Pools for the az must be created before this domain fabric module executes
  depends_on = [
    module.imm_az_pools_mod, module.imm_az_user_policy_1, module.server_policies,
  ]

}