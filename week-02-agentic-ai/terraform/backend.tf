# Terraform state backend configuration.
# First run: terraform init (without this backend block)
# Then create the resources and verify the deployment.
# After that, uncomment the block below and run:
# terraform init -migrate-state

# terraform {
#   backend "s3" {
#     bucket = "your-terraform-state-bucket"
#     key    = "portfolio-site/terraform.tfstate"
#     region = "ap-south-1"
#     encrypt = true
#   }
# }
