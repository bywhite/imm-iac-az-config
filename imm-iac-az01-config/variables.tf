# Variables are used to increase code re-use and improve security of sensitive data through abstraction

# Sensitive information should be stored in variables (var.<variable>) to be passed in from external sources
#    Terraform Variables can be passed in from TFCB, CLI apply parameters and environment variables (TF_VAR_<var-name>)

#  All Main Module variables listed should be Set in TFCB "Workspace" > "Variables"
#  The following are defined as variables in the designated TFCB workspace
#       endpoint (http://intersight.com)
#       api_key  (ID for Intersight)
#       secretkey (Key for Intersight)
#       imc_admin_password


# https://intersight.com/an/settings/api-keys/
## Generate API key to obtain the API key and secret key
variable "apikey" {
    description = "API key for Intersight account"
    type        = string
}

variable "secretkey" {
    description = "Filename that provides secret key for Intersight API"
    type        = string
}

# This is the Intersight URL (could be URL to Intersight Private Virtual Appliance instead)
variable "endpoint" {
    description = "Intersight API endpoint"
    type        = string
    default     = "https://intersight.com"
}

# This is the target organization defined in Intersight to be configured
variable "organization" {
    description = "Intersight Organization target for object creation"
    type        = string
    default     = "imm-iac-az"
}

variable "az_policy_prefix" {
    description = "Prefix to be prepended to all IMM object names"
    type        = string
    default     = "dc01-az01"
}

variable "az_id" {
    description = "Unique ID for domain and AZ.  DC-1, AZ-2 is az_id=12"
    type        = string
    default     = "11"
}

variable "az_vlans" {
    description = "VLANs defined on FI and all Uplinks"
    type        = string
    default     = "100,101,200-599,997-999,1200-1250"
}

variable "az_description" {
    description = "Default description for all objects created"
    type        = string
    default     = "Created by Terraform"
}

variable "imc_admin_password" {
    type    = string
    default = "password"
}
variable "snmp_password" {
    type    = string
    default = "password"
}
