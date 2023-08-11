# # =============================================================================
# # This defines a Server Policies for all Server Profile Templates 
# # Builds: Server Profile Template and associated Server Resource Pool
# #    * Note: Derivation of Server Profiles is outside of TF scope
# # Duplicate this code/file to add another new Server Template and:
# #    * Change module: "server_template_vmwX"  >> "server_template_vmwY"
# #    * Change server_policy_prefix: "...-vmwX" > "...-vmwY"
# #    * Change Tag value for "ServerGroup" to include new name
# #    * Modify parameters as needed to tweak your template configuration
# # -----------------------------------------------------------------------------


module "server_policies" {
  source = "github.com/bywhite/imm-iac-az-mods//imm-srv-policies-mod"  #?ref=v0.0.1"
            # remote module source above should not be changed when duplicating

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------
  # external sources
  organization    = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # prefix for all created policies
  policy_prefix = "${var.az_policy_prefix}"        
  description   = "built by Terraform ${var.az_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "az", "value" : "${var.az_policy_prefix}" }
  ]


# =============================================================================
# Server vlan groups (network vlan groups)
# -----------------------------------------------------------------------------

  vlan_groups = {
    "esx7u3_v1"  = {
      net_group_name   = "netgroup01"
      native_vlan = 44
      vlan_range  = "44,50,1000-1011"
    }
    "winsrv2022_v1"  = {
      net_group_name   = "netgroup02"
      native_vlan = 44
      vlan_range  = "44,50,1000-1011"
    }
  }

# =============================================================================
# Local IMC access policy
# -----------------------------------------------------------------------------

  imc_access_vlan           = 21

# =============================================================================
# AZ Server Pools
# -----------------------------------------------------------------------------

  mac_pool_moid         = module.imm_az_pools_mod.mac_pool_moid
  imc_ip_pool_moid      = module.imm_az_pools_mod.ip_pool_moid
  wwnn_pool_moid        = module.imm_az_pools_mod.wwnn_pool_moid
  wwpn_pool_a_moid      = module.imm_az_pools_mod.wwpn_pool_a_moid
  wwpn_pool_b_moid      = module.imm_az_pools_mod.wwpn_pool_b_moid
  server_uuid_pool_moid = module.imm_az_pools_mod.uuid_pool_moid
  server_uuid_pool_name = module.imm_az_pools_mod.uuid_pool_name

# =============================================================================
# SNMP policy
# -----------------------------------------------------------------------------

  snmp_ip       = "10.10.10.10"
  snmp_password = "C1sc0123!"             #Recommend adding var to TFCB Workspace
  
# =============================================================================
# Syslog policy
# -----------------------------------------------------------------------------

  syslog_remote_host = "10.10.10.10"

# =============================================================================
# Dependencies
# -----------------------------------------------------------------------------
# The Pools for the az must be created before this domain fabric module executes
  depends_on = [
    module.imm_az_pools_mod, module.imm_az_user_policy_1,
    module.imm_az_qos_mod, module.imm_az_vsan_policy_1
  ]

}