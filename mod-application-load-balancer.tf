module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.5.0"

  name               = "alb-for-wordpress"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_sg.security_group_id]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = aws_acm_certificate.my_certificate_request.arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  target_groups = [
    {
      name_prefix          = "WPress"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 60
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 80
        healthy_threshold   = 2
        unhealthy_threshold = 5
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      # targets = [
      #   {
      #     target_id = aws_instance.ec2_in_private_subnet.id
      #     port      = 80
      #   }
      # ]
    }
  ]

  tags = {
    Environment = "Test"
  }
}