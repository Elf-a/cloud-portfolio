data "aws_ecr_repository" "app" {
  name = var.project
}

resource "aws_ecs_cluster" "this" {
  name = var.project
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project}"
  retention_in_days = 14
}


variable "container_image_tag" {
  type        = string
  description = "Tag to deploy from ECR"
  default     = "latest"
}

variable "app_key" {
  type        = string
  description = "Laravel APP_KEY (base64:...)"
  default     = "base64:PNzSTd6tpXl2WOoUOkFvZWCneb4HG+yyHun2G+6x7+s="
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.project
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name         = "webapp",
      image        = "${data.aws_ecr_repository.app.repository_url}:${var.container_image_tag}",
      essential    = true,
      portMappings = [{ containerPort = 80, protocol = "tcp" }],
      environment = [
        { name = "APP_ENV", value = var.env },
        { name = "APP_DEBUG", value = "false" },
        { name = "APP_KEY", value = var.app_key },
        { name = "DB_CONNECTION", value = "pgsql" },
        { name = "DB_HOST", value = aws_db_instance.postgres.address },
        { name = "DB_PORT", value = "5432" },
        { name = "DB_DATABASE", value = var.db_name },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "DB_PASSWORD", value = var.db_password }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name,
          awslogs-region        = var.aws_region,
          awslogs-stream-prefix = "webapp"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = var.project
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default_all.ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "webapp"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}