# S3 remote state for machine learning app 
terraform {
 backend "s3" {
    bucket         = "ecs-project"  
    key            = "project/ecs"
    region         = "us-east-2"
    dynamodb_table = "eks_ecommerce_dynamodb"

 }
} 
