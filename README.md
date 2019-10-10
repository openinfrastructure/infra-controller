# GCP Infrastructure Controller

This repository provides a step by step tutorial to create the infrastructure
foundations for a GCP organization.  The intended use case is an enterprise
customer deploying workloads into GCP.

Enterprises typically have centralized infrastructure, for example one prod and
one nonprod environment each with a Shared VPC network, Hybrid Connectivity,
Firewall Rules, Organization Policies, IAM policies, and Logging configuration.

Application teams develop changes in their own service projects using the
nonprod infrastructure.  Changes are ultimately deployed into the production
environment.

The infrastructure controller provides a smooth on-ramp to manage the prod and
nonprod centralized infrastructure using CI/CD and Terraform Infrastructure as
Code techniques.

# What you will build

 * One environment, `nonprod`, with:
 * An infra-controller Service Account to manage the shared infrastructure for
   the environment.
 * A GCS Bucket to hold Terraform state for the environment.
 * A [GitLab Runner][runner] to execute Terraform in a CI/CD pipeline.

Additional environments, e.g. prod, may be created by repeating this process.

Note: The runner is intended solely to control the infrastructure, it should
not be shared with development teams because the runner has access to a service
account with elevated access across the GCP organization.

# What you need

 * A newly created GCP project.  For example, `infra-controller-nonprod` with a
   project id of `infra-controller-nonprod-123456`.
 * [Owner][roles] of the project.
 * A GitLab Runner [registration token][token]

# Tutorial

Execute these tutorials in order to get started.

| Step            | Description                                | Run                                            |
| ----            | ----                                       | ----                                           |
| State Bucket    | Create a state bucket                      | [![Open in Cloud Shell][shell_img]][setup_gcs] |
| Service Account | Create a service account for Terraform     | TODO                                           |
| GitLab Runner   | Create GitLab runners to execute Terraform | TODO                                           |

[open]: https://cloud.google.com/blog/products/gcp/introducing-open-in-cloud-shell-a-new-way-to-create-frictionless-tutorials
[shell_img]: https://gstatic.com/cloudssh/images/open-btn.png
[setup_gcs]: https://console.cloud.google.com/cloudshell/open?shellonly=true&cloudshell_git_repo=https://github.com/openinfrastructure/infra-controller&cloudshell_tutorial=resources/setup_state_bucket.md
[runner]: https://docs.gitlab.com/runner/
[roles]: https://cloud.google.com/iam/docs/understanding-roles
[token]: https://docs.gitlab.com/ee/ci/runners/#registering-a-group-runner
