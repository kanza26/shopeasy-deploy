output "backend_ecr_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr_backend.repository_url
}

output "frontend_ecr_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr_frontend.repository_url
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
