#Cloudwatch log group 
resource "aws_cloudwatch_log_group" "feather_log" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 30
}

#Cloudwatch log stream 
resource "aws_cloudwatch_log_stream" "feather_stream" {
  name           = var.cloudwatch_log_stream 
  log_group_name = aws_cloudwatch_log_group.feather_log.name
}


#ALB 
resource "aws_lb" "feather_lb" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.feather_alb.id ]
  subnets            = [ aws_subnet.app_public_subnets[0].id, aws_subnet.app_public_subnets[1].id ]
          
  enable_deletion_protection = false
}

#ALB target group
resource "aws_alb_target_group" "feather_alb_tg_group" {
  name         = "${var.name}-tg"
  port         = 80

  protocol     = "HTTP"
  vpc_id       = aws_vpc.app_vpc.id
  target_type  = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    timeout             = "3"
    path                = var.health_check_path   
    unhealthy_threshold = "2"
  }

  depends_on =  [ aws_lb.feather_lb ]
}

resource "aws_alb_listener" "ecs_alb_http_listner" {
  load_balancer_arn = aws_lb.feather_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.feather_alb_tg_group.arn
  }

  depends_on        = [ aws_alb_target_group.feather_alb_tg_group ]
}

#ECS Cluster 
resource "aws_ecs_cluster" "feather_cluster" {
  name = "${var.name}-cluster"
}

#ECS Task Definition 
resource "aws_ecs_task_definition" "node_definition" {
  count                    = var.create ? 1:0 
  family                   = "${var.name}-app"
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions = <<EOF
[
  {
    "image": "${var.docker_image}",
    "name": "${local.environment_prefix}-app",
    "essential": true,
    "cpu": 256,
    "memoryReservation": 512,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "mountPoints": [],
    "entryPoint": [],
    "command": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${var.aws_region}",
        "awslogs-group": "${var.cloudwatch_log_group_name}",
        "awslogs-stream-prefix": "${var.cloudwatch_log_stream}"
      }
    },
   
    "placement_constraints": [],
   
    "volume": []
  }
]
EOF
}


#ECS Service 
resource "aws_ecs_service" "app_service" {
  name                               = "${var.name}-service" 
  cluster                            = aws_ecs_cluster.feather_cluster.id
  task_definition                    = aws_ecs_task_definition.node_definition[0].arn
  desired_count                      = 1
  launch_type                        = "FARGATE" 
  scheduling_strategy                = "REPLICA"
  platform_version                   = "LATEST"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  #health_check_grace_period_seconds  = 60   
  #iam_role                           = aws_iam_role.feather_svc.arn  
  depends_on                         = [ aws_iam_role.feather_svc ] 

  network_configuration {
    security_groups  = [ aws_security_group.feather_alb.id, aws_security_group.feather_service.id ]
    subnets          = [ aws_subnet.app_public_subnets[0].id ,  aws_subnet.app_public_subnets[1].id ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.feather_alb_tg_group.arn
    container_name   = "${local.environment_prefix}-app"
    container_port   = var.node_container_port
  }
}
