data "aws_ssm_parameter" "read" {
  count = var.enabled == "true" ? length(var.parameter_read) : 0
  name  = element(var.parameter_read, count.index)
}

resource "aws_ssm_parameter" "default" {
  count           = var.enabled == "true" ? length(var.parameter_write) : 0
  name            = lookup(var.parameter_write[count.index], "name")
  description     = lookup(var.parameter_write[count.index], "description", lookup(var.parameter_write[count.index], "name"))
  type            = lookup(var.parameter_write[count.index], "type", "SecureString")
  value           = lookup(var.parameter_write[count.index], "value")
  overwrite       = lookup(var.parameter_write[count.index], "overwrite", "true")
  allowed_pattern = lookup(var.parameter_write[count.index], "allowed_pattern", "")
  tags            = var.tags
}
