variable "vpc" {
  type = object({
    id   = string
    name = string
  })

  description = "VPC ID & name."
}

variable "mode" {
  type        = string
  description = <<EOF
Available modes for the module are:
* private - no infrastructure is created
* igw-only - only Internet Gateway is created; required in private VPCs when a service is exposed with AWS Global Accelerator
* public - all infrastructure is created
EOF

  validation {
    condition     = contains(["none", "igw-only", "public"], var.mode)
    error_message = "Public infrastructure module mode must be one of: none, igw-only, public."
  }
}

variable "azs_cidr_blocks" {
  type        = map(string)
  description = "Map of AZs with the IPv4 CIDR block to be used for each public subnet."
}

variable "nat_gateway_setup" {
  type        = string
  description = "NAT Gateway setup. Available options: one-az, failover, ha"

  validation {
    condition     = contains(["one-az", "failover", "ha"], var.nat_gateway_setup)
    error_message = "NAT Gateway setups available are: one-az, failover, ha."
  }
}

variable "empty_network_acl" {
  type        = bool
  description = "Do not create default allow all traffic rule in network ACL."
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all resources created by this module. Reserved tag keys: Name, net/type"
}
