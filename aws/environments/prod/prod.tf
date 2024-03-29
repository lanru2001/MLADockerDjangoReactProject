module "ecs_prod" {
  
  source                    = ../..    
  vpc_cidr                  = "172.16.0.0/16"
  public_subnets_cidr       = [ "192.168.6.0/24" , "192.168.7.0/24" ]
  private_subnets_cidr      = [ "192.168.8.0/24" , "192.168.9.0/24" ]
  create                    = true
  name                      = "node"
  namespace                 = "dynamic"
  docker_image              = "873079457075.dkr.ecr.us-east-2.amazonaws.com/node-test-app"
  environment               = "nodejs"
  stage                     = "prod"
  aws_region                = "us-east-2"
  azs                       = ["us-east-2a" , "us-east-2b"]
  cloudwatch_log_group_name = "ecs/dynamic-nodejs-dev"
  cloudwatch_log_stream     = "ecs"
  bucket_name               = "dynamic-lb-logs"
  node_container_port       = "80"
  name_prefix               = "light-app"
  health_check_path         = "/robots.txt"
  ami_id                    = "ami-03d64741867e7bb94"
  #public_subnet_id         =  { "subnet-097c6f21a3fc9e20a" }
  PATH_TO_PUBLIC_KEY        = "mykey.pub"
  PATH_TO_PRIVATE_KEY       = "mykey"
  db_name                   = "eks_db"
  db_instance_port          = 5432
  username                  = "postgresqladmin" 
  password                  = "arn:aws:secretsmanager:us-east-2:873079457075:secret:dev/Passwd/mysql-GbpmcV"  
  family                    = "postgresql13"
  private_subnet_id         = "subnet-0c6700f2915010226" 
  engine                    = "Postgresql"
  engine_version            = "13.3"
  instance_class            = "db.t2.micro"
  #db_subnet_group_name     = "subnet-097c6f21a3fc9e20a"     # "subnet-0c6700f2915010226" # "subnet-05731ba59cb081e63"]
  tag                       = "app-dev"
  container_port            = 8080
  disk_size                 = 10
  pvt_desired_size          = 2
  pvt_max_size              = 2
  pvt_min_size              = 2
  publ_desired_size         = 2
  publ_max_size             = 2
  publ_min_size             = 2
  desired_size              = 2 
  instance_type             = "t2.medium" 

}
