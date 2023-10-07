# # =============================================================================
# # This defines all of the external data references
# # Mostly consumed by the az-srvt-with-abstract-data-ref.tf
# # This demonstrates the alternative to module.* references
# # Note: data references require external queries, module references don't
# # -----------------------------------------------------------------------------

# =============================================================================
# az-wide pools
# -----------------------------------------------------------------------------

data "intersight_macpool_pool" "macpool_1" {
    name = "${var.az_policy_prefix}-pool-mac-1"
}
data "intersight_ippool_pool" "ippool_1" {
    name = "${var.az_policy_prefix}-pool-ip-imc-1"
}
data "intersight_fcpool_pool" "wwnnpool_1" {
    name = "${var.az_policy_prefix}-pool-wwnn-1"
}
data "intersight_fcpool_pool" "wwpnpoola_1" {
    name = "${var.az_policy_prefix}-pool-wwpn-a-1"
}
data "intersight_fcpool_pool" "wwpnpoolb_1" {
    name = "${var.az_policy_prefix}-pool-wwpn-b-1"
}
data "intersight_uuidpool_pool" "uuidpool_1" {
    name = "${var.az_policy_prefix}-pool-uuid-1"
}

# =============================================================================
# az-wide server policies
# -----------------------------------------------------------------------------
data "intersight_access_policy" "access_1" {
    name = "${var.az_policy_prefix}-access-1"
}
data "intersight_bios_policy" "bios_1" {
    name = "${var.az_policy_prefix}-bios-1"
}
data "intersight_boot_precision_policy" "boot_1" {
    name = "${var.az_policy_prefix}-boot-1"
}
data "intersight_ipmioverlan_policy" "ipmi_1" {
    name = "${var.az_policy_prefix}-ipmi-1"
}
data "intersight_kvm_policy" "kvm_1" {
    name = "${var.az_policy_prefix}-kvm-1"
}
data "intersight_power_policy" "power_3" {
    name = "${var.az_policy_prefix}-power-3"
}
data "intersight_snmp_policy" "snmp_1" {
    name = "${var.az_policy_prefix}-snmp-1"
}
data "intersight_sol_policy" "sol_1" {
    name = "${var.az_policy_prefix}-sol-1"
}
data "intersight_storage_storage_policy" "stor_3" {
    name = "${var.az_policy_prefix}-stor-3"
}
data "intersight_syslog_policy" "syslog_1" {
    name = "${var.az_policy_prefix}-syslog-1"
}
data "intersight_vmedia_policy" "vmedia_1" {
    name = "${var.az_policy_prefix}-vmedia-1"
}
data "intersight_vnic_lan_connectivity_policy" "lancon_4" {
    name = "${var.az_policy_prefix}-lancon-4"
}
data "intersight_vnic_san_connectivity_policy" "sancon_2" {
    name = "${var.az_policy_prefix}-sancon-2"
}

# =============================================================================
# az-wide user policies for IMC access
# -----------------------------------------------------------------------------
data "intersight_iam_end_point_user_policy" "userpol_1" {
    name = "${var.az_policy_prefix}-imc-user-policy1"
}

