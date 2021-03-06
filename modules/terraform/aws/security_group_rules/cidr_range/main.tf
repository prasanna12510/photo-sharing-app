resource "aws_security_group_rule" "main" {
  count = var.ingress_rules_count
  description       = var.ingress_rules[count.index].description
  from_port         = var.ingress_rules[count.index].from_port
  protocol          = var.ingress_rules[count.index].protocol
  security_group_id = var.sg_id
  cidr_blocks       = ["${var.ingress_rules[count.index].cidr_blocks}"]
  to_port           =  var.ingress_rules[count.index].to_port
  type              =  var.type
}
