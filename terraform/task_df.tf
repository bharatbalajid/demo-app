resource "aws_ecs_task_definition" "demo-app-task" {
  family                   = "demo-app"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name  = "demo-app-container"
      image = "223150837745.dkr.ecr.us-east-1.amazonaws.com/demo-app:latest"
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}
resource "aws_ecs_service" "demo-app-service" {
  name            = "demo-app-service"
  cluster         = aws_ecs_cluster.mydemoapp.arn
  task_definition = aws_ecs_task_definition.demo-app-task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = ["${aws_subnet.my_public_SN1.id}", "${aws_subnet.my_public_SN2.id}", "${aws_subnet.my_public_SN3.id}"]
    security_groups  = ["${aws_security_group.mysg.id}"]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.demo-app-target-group.arn
    container_name   = "demo-app-container"
    container_port   = var.container_port
  }
  deployment_controller {
    type = "ECS"
  }
}
