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


module "server_template_abstract_data_ref" {                                   # <<-- Change to duplicate
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
  server_template_name = "${var.az_policy_prefix}-srvt-dataref-01"         # <<-- Change to duplicate
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
  mac_pool_moid         = data.intersight_macpool_pool.macpool_1.id
  imc_ip_pool_moid      = data.intersight_ippool_pool.ippool_1.id
  wwnn_pool_moid        = data.intersight_fcpool_pool.wwnnpool_1.id
  wwpn_pool_a_moid      = data.intersight_fcpool_pool.wwpnpoola_1.id
  wwpn_pool_b_moid      = data.intersight_fcpool_pool.wwpnpoolb_1.id
  server_uuid_pool_moid = data.intersight_uuidpool_pool.uuidpool_1.id

# =============================================================================
# az-wide server policies
# -----------------------------------------------------------------------------
  access_policy     = data.intersight_access_policy.access_1.id
  bios_policy       = data.intersight_bios_policy.bios_1.id
  boot_policy       = data.intersight_boot_precision_policy.boot_1.id
  ipmi_policy       = data.intersight_ipmioverlan_policy.ipmi_1.id
  kvm_policy        = data.intersight_kvm_policy.kvm_1.id
  power_policy      = data.intersight_power_policy.power_3.id
  snmp_policy       = data.intersight_snmp_policy.snmp_1.id
  sol_policy        = data.intersight_sol_policy.sol_1.id
  stor_policy       = data.intersight_storage_storage_policy.stor_3.id
  syslog_policy     = data.intersight_syslog_policy.syslog_1.id
  vmedia_policy     = data.intersight_vmedia_policy.vmedia_1.id
  lancon_policy     = data.intersight_vnic_lan_connectivity_policy.lancon_4.id
  sancon_policy     = data.intersight_vnic_san_connectivity_policy.sancon_2.id

# =============================================================================
# Local IMC Users - defined az wide
# -----------------------------------------------------------------------------
  # Sets local users and their permissions and passwords
  user_policy = data.intersight_iam_end_point_user_policy.userpol_1.id 

# =============================================================================
# Dependencies
# -----------------------------------------------------------------------------
# The Pools for the az must be created before this domain fabric module executes
  depends_on = [
    module.imm_az_pools_mod, module.imm_az_user_policy_1, module.server_policies,
  ]

}