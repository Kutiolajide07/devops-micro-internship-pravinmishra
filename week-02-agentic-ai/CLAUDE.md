# AGENTS

## Project Overview

This repository is part of the DevOps Micro Internship (DMI) Cohort 3.

It demonstrates Infrastructure as Code (IaC) using Terraform. Claude should provide guidance that aligns with Terraform workflows, DevOps practices, and Infrastructure as Code principles.

## Workspace summary

Current project structure includes:

- Terraform configuration files
  - main.tf
  - provider.tf
  - variables.tf
  - outputs.tf
  - versions.tf

- terraform/
  - backend.tf
  - main.tf
  - providers.tf
  - variables.tf
  - outputs.tf

- .claude/skills/
  - deploy
  - scaffold-terraform
  - tf-plan
  - tf-apply

- README.md

This repository demonstrates Infrastructure as Code (IaC) using Terraform.

## Guidance for AI coding agents

- Treat this as a Terraform Infrastructure as Code project.
- Recommend Terraform best practices.
- Prefer modifying existing Terraform configuration instead of creating duplicate files.
- Preserve the existing project structure.
- Explain infrastructure changes before applying them.
- Never recommend converting this repository into a frontend application.

## Useful checks for future work

Before deployment always run:

terraform fmt

terraform init

terraform validate

terraform plan

terraform apply

Always review the output of terraform plan before applying changes.

## Coding Standards

- Use descriptive resource and variable names.
- Keep Terraform code formatted using `terraform fmt`.
- Avoid hardcoded values where variables can be used.
- Keep Terraform modules reusable and well documented.
- Follow Terraform best practices for readability and maintainability.

## Project Rules

- Keep this project focused on Terraform and DevOps.
- Do not convert this project into React.
- Do not replace Terraform with another Infrastructure as Code tool.
- Follow Infrastructure as Code best practices.
- Keep Terraform modules reusable and well documented.
