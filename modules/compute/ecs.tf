resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.environment}-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-${var.environment}-app"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_secret_arn
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.alb_sg]
    assign_public_ip = false
  }


  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "${var.project_name}-${var.environment}-app"
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_listener.http
  ]
}