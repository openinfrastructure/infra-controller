# Terraform State Bucket

Terraform stores state in the local file system by default, which is
problematic when managing infrastructure using CI/CD pipelines.  CI/CD jobs
discard the local file system after each execution.  You'll overcome this
challenge by creating a GCS bucket to store Terraform state.

## Let's get started!

Select your Infrastructure Controller project for your environment.  For
example, `infra-controller-nonprod-123456`.


