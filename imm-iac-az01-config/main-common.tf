# =============================================================================
# Each UCS Domain Infrastructure is defined by its own file and module call.
# Each Server Profile Template is defined by its own file and module call.
# The Server Profile Templates rely upon common shared policies below.  

# COMMON objects shared throughout az for consistent configurations:
#   - IMC Local User Policies                   (module imm_az_user_policy_1)
#   - az Server VSAN Policies                  (module imm_az_vsan_policy_1)
#   - QoS Policies for Server Template vNic's   (module imm_az_qos_mod)
#   - az Pools: IP, MAC, UUID, WWNN, WWPN      (module imm_az_pools_mod)
#   - All Server Template Supporting Policies
# =============================================================================


# =============================================================================
# IMC Local User Policies
# -----------------------------------------------------------------------------
# Consumed by Server Profiles or Sever Templates with:
# USAGE:  module.az_user_policy.user_policy_moid 

module "imm_az_user_policy_1" {
  source = "github.com/bywhite/imm-iac-az-mods//imm-imc-user-mod"
  
  # external sources
  organization       = local.org_moid
  az_policy_prefix  = var.az_policy_prefix
  description        = "az User Policy 1"
  tags               = local.az_tags
  imc_admin_password = var.imc_admin_password
}


# =============================================================================
#   - az Server VSAN Policies
# -----------------------------------------------------------------------------
# Consumed by Server Profiles or Sever Templates with:
# This must match up with domain fabric's (FI's) vSAN Configuration
# USAGE:
#   vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_100_moid
#   vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_101_moid
#   vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_102_moid
#   vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_200_moid
#   vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_201_moid
#   vsan_moid      = module.imm_az_vsan_policy_1.fc_vsan_202_moid


module "imm_az_vsan_policy_1" {
  source = "github.com/bywhite/imm-iac-az-mods//imm-vsan-mod"
  
  # external sources
  organization       = local.org_moid
  policy_prefix  = var.az_policy_prefix
  description        = "az VSAN Policy 1"
  tags = local.az_tags
  
  
  # az wide SAN Boot Policies, each boot policy with four FC Adapter Boot options
  # Usage: boot_moid = module.imm_az_vsan_policy_1.boot_policy_list["boot-11"]
  san_boot_policies   = {
    "boot-11" = {
      device_name_1    = "vHBA0-Primary"
      int_name_1       = "fc0"
      boot_lun_1       = 0
      target_wwpn_1    = "20:11:00:00:00:00:00:4B"
      device_name_2    = "vHBA0-Secondary"
      int_name_2       = "fc0"
      boot_lun_2       = 0
      target_wwpn_2    = "20:12:00:00:00:00:00:4B"
      device_name_3    = "vHBA1-Primary"
      int_name_3       = "fc1"
      boot_lun_3       = 0
      target_wwpn_3    = "20:13:00:00:00:00:00:4B"
      device_name_4    = "vHBA1-Secondary"
      int_name_4       = "fc1"
      boot_lun_4       = 0
      target_wwpn_4    = "20:14:00:00:00:00:00:4B"
    }
    "boot-12" = {
      device_name_1    = "vHBA0-Primary"
      int_name_1       = "fc0"
      boot_lun_1       = 0
      target_wwpn_1    = "20:12:00:00:00:00:00:4B"
      device_name_2    = "vHBA0-Secondary"
      int_name_2       = "fc0"
      boot_lun_2       = 0
      target_wwpn_2    = "20:15:00:00:00:00:00:4B"
      device_name_3    = "vHBA1-Primary"
      int_name_3       = "fc1"
      boot_lun_3       = 0
      target_wwpn_3    = "20:23:00:00:00:00:00:4B"
      device_name_4    = "vHBA1-Secondary"
      int_name_4       = "fc1"
      boot_lun_4       = 0
      target_wwpn_4    = "20:11:00:00:00:00:00:4B"
    }
  }

}


# =============================================================================
# QoS Policies for Server Template vNic's
# -----------------------------------------------------------------------------
# Creates vNic QoS Policies for each active class of service (CoS)
# This must match up with domain fabric's System QoS Policy and
# match up with external network's QoS configurations
# Consumed by Server Profile Templates with:
# USAGE:  
#   qos_moid    = module.imm_az_qos_mod.vnic_qos_besteffort_moid
#   qos_moid    = module.imm_az_qos_mod.vnic_qos_bronze_moid
#   qos_moid    = module.imm_az_qos_mod.vnic_qos_silver_moid
#   qos_moid    = module.imm_az_qos_mod.vnic_qos_gold_moid
#   qos_moid    = module.imm_az_qos_mod.vnic_qos_platinum_moid
#   qos_moid    = module.imm_az_qos_mod.vnic_qos_fc_moid

module "imm_az_qos_mod" {       
  source = "github.com/bywhite/imm-iac-az-mods//imm-srv-qos-mod"

# external references
  org_id        = local.org_moid
  policy_prefix = var.az_policy_prefix
  description   = "built by Terraform for ${var.az_policy_prefix}"
  tags          = local.az_tags

}

# =============================================================================
# az Pools: IP, MAC, UUID, WWNN, WWPN
# -----------------------------------------------------------------------------
# Creates sequential identity pools for server templates and chassis
# Consumed by Server Profiles or Sever Templates with:
# SERVER USAGE:  
  # mac_pool_moid         = module.imm_az_pools_mod.mac_pool_moid
  # imc_ip_pool_moid      = module.imm_az_pools_mod.ip_pool_moid
  # wwnn_pool_moid        = module.imm_az_pools_mod.wwnn_pool_moid
  # wwpn_pool_a_moid      = module.imm_az_pools_mod.wwpn_pool_a_moid
  # wwpn_pool_b_moid      = module.imm_az_pools_mod.wwpn_pool_b_moid
  # server_uuid_pool_moid = module.imm_az_pools_mod.uuid_pool_moid
  # server_uuid_pool_name = module.imm_az_pools_mod.uuid_pool_name
# CHASSIS USAGE:
  # chassis_imc_ip_pool_moid = module.imm_az_pools_mod.ip_pool_chassis_moid

module "imm_az_pools_mod" {
  source = "github.com/bywhite/imm-iac-az-mods//imm-pools-mod"
  
  # external sources
  organization    = local.org_moid
  policy_prefix = var.az_policy_prefix
  az_id = var.az_id                   # used to create unique identity Pools: MAC, WWNN, WWPN
  description   = var.az_description       # Using generic az description

# Server Inband IP Pool values for Server IMC
  ip_size     = "18"
  ip_start = "192.168.21.100"
  ip_gateway  = "192.168.21.1"
  ip_netmask  = "255.255.255.0"
  ip_primary_dns = "192.168.60.7"

# Chassis Inband IP Pool values for Chassis IMC
  chassis_ip_size     = "4"
  chassis_ip_start = "192.168.21.118"
  chassis_ip_gateway  = "192.168.21.1"
  chassis_ip_netmask  = "255.255.255.0"
  chassis_ip_primary_dns = "192.168.60.7"

  tags = local.az_tags

}


# =============================================================================
# =============================================================================
