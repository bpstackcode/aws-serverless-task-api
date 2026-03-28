# AWS Serverless Task API

A cloud-native, serverless REST API for task management built with AWS Lambda, API Gateway, and DynamoDB — provisioned entirely with Terraform and deployed via GitHub Actions CI/CD.

## Architecture

- AWS Lambda — Python 3.12 functions for each CRUD operation
- API Gateway — RESTful HTTP endpoints
- DynamoDB — NoSQL database for task storage
- IAM — Least privilege roles per Lambda function
- Terraform — Infrastructure as Code for all AWS resources
- GitHub Actions — Automated CI/CD pipeline on every push to main

## Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /tasks | Create a new task |
| GET | /tasks | Retrieve all tasks |
| PUT | /tasks/{task_id} | Update an existing task |
| DELETE | /tasks/{task_id} | Delete a task |

## Security

- IAM roles scoped to least privilege
- No hardcoded credentials — AWS secrets stored in GitHub Secrets
- Infrastructure managed as code for full auditability

## Tech Stack

Terraform · AWS Lambda · API Gateway · DynamoDB · Python 3.12 · GitHub Actions · IAM
