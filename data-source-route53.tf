#======================================================================
# fetch pre-existing zone created by route53 during domain rehisteration
#=======================================================================
data "aws_route53_zone" "route53_domain" {
  name         = var.route53_public_zone_name
  private_zone = false
}
