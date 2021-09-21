resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.route53_domain.zone_id
  name    = "www.${data.aws_route53_zone.route53_domain.name}"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_health_check" "route53_health_check" {
  fqdn              = aws_route53_record.www.name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "2"
  request_interval  = "10"

  tags = {
    Name = "app-load-balancer-health-check"
  }
}


