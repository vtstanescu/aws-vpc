resource "aws_network_acl" "private" {
  vpc_id     = local.vpc_id
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  dynamic "ingress" {
    for_each = var.private_nacl_rules == {} ? local.defaults.private_nacl_rules.inbound : lookup(var.private_nacl_rules, "inbound", [])
    iterator = rule

    content {
      rule_no    = rule.value["rule_no"]
      protocol   = rule.value["protocol"]
      from_port  = rule.value["from_port"]
      to_port    = rule.value["to_port"]
      icmp_type  = lookup(rule.value, "icmp_type", null)
      icmp_code  = lookup(rule.value, "icmp_code", null)
      cidr_block = rule.value["cidr_block"]
      action     = rule.value["action"]
    }
  }

  dynamic "egress" {
    for_each = var.private_nacl_rules == {} ? local.defaults.private_nacl_rules.outbound : lookup(var.private_nacl_rules, "outbound", [])
    iterator = rule

    content {
      rule_no    = rule.value["rule_no"]
      protocol   = rule.value["protocol"]
      from_port  = rule.value["from_port"]
      to_port    = rule.value["to_port"]
      icmp_type  = lookup(rule.value, "icmp_type", null)
      icmp_code  = lookup(rule.value, "icmp_code", null)
      cidr_block = rule.value["cidr_block"]
      action     = rule.value["action"]
    }
  }

  tags = merge(var.tags, { Name = "${local.derived_prefix}-private-nacl" })
}
