resource "aws_lb" "demo-app-alb" {
  name               = "demo-app-alb"
  internal           = false
  load_balancer_type = "application"

  subnet_mapping {
    subnet_id = aws_subnet.my_public_SN1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.my_public_SN2.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.my_public_SN3.id
  }
  security_groups = [aws_security_group.mysg.id]
}
resource "aws_lb_target_group" "demo-app-target-group" {
  name        = "demo-app-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.myvpc.id
}
resource "aws_lb_listener" "demo-app-listener" {
  load_balancer_arn = aws_lb.demo-app-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, world!"
      status_code  = "200"
    }
  }
}
resource "aws_lb_listener_rule" "demo-app-listener-rule" {
  listener_arn = aws_lb_listener.demo-app-listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-app-target-group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}


