# Terraform State Bucket

Terraform stores state in a state file using the [local backend][local-backend]
by default.  You'll create a GCS bucket to hold the state file in this walk
through.

A storage bucket backend is better than the local filesystem for a team of
people working together.

## Overview

### You will

 1. Set input values for the project id and environment
 2. Use Terraform to create the GCS bucket
 3. Move the state file into the GCS bucket

### You will need

 1. The name of the environment you will manage, e.g. `nonprod` or `prod`.
 2. The project id of the infra-controller project.

If you need to create a project, you may do so now with gcloud or [Cloud
Console][new-project].

You should pick a descriptive name for this project, which will contain all of
the resources to control the infrastructure for the environment.  For example,
a name of `infra-controller-nonprod` and a project id of
`infra-controller-nonprod-12345`

### Let's get started!

Click start to setup your environment.

## Input Values

### Project ID

Set the project id which will contain the state bucket.

```bash
export PROJECT_ID=<your_project_id>
```

You may list available projects using

```bash
gcloud projects list
```

### Environment Name

Set the environment name.  This should be `prod` or `nonprod`, suggest starting
with `nonprod`.

```bash
export ENV=nonprod
```

### Bucket Name

Set the bucket name, suggest using `tf-state-${ENV}-${RANDOM}`.

```bash
export TF_STATE_BUCKET="tf-state-${ENV}-${RANDOM}"
```

### GCS Location (Optional)

Optionally customize the [GCS Location][gcs-loc] of the storage bucket.

```bash
export TF_VAR_location=us-west1
```

### Next step

Next you'll run terragrunt which will use these values to create the bucket.

## Terraform & Terragrunt Docker Container

You'll run terraform to create the backend GCS state bucket.

Terraform will store state on the local file system temporarily.  Once the
bucket is created Terraform will move the state file into the bucket.

You'll use [Terragrunt][terragrunt] to manage the Terraform back end state
configuration once the state bucket exists.

### Container

Terraform runs conveniently from a Docker container.  You'll enter a shell
inside the container for the rest of this walk through.

Note, you should be in the root of the infra-controller directory when this
command is run.

```bash
docker run -it \
  -e TF_VAR_project_id=${PROJECT_ID} \
  -e TF_VAR_bucket_name=${TF_STATE_BUCKET} \
  -e TF_VAR_location \
  -e TF_STATE_BUCKET \
  -v `pwd`:/apps \
  alpine/terragrunt:0.12.9 \
  bash
```

### Change working directory

Change your working directory into the `infra/state_bucket/` directory.

```bash
cd infra/state_bucket/
```

### Next step

Next, you'll run terraform to create the GCS bucket.

## Manage the GCS bucket

### Disable the GCS Backend

You'll need to comment out the GCS Backend configuration to create the bucket.
Open the main.tf file in the infra/state_bucket/ directory and comment out the
`terraform` block as in the following example.  <walkthrough-editor-open-file
filePath="infra-controller/infra/state_bucket/main.tf" text="Open
infra/state_bucket/main.tf"></walkthrough-editor-open-file>

```terraform
terraform {
  # backend "gcs" {}
}
```

Terraform will fail with `Backend reinitialization required. Please run
"terraform init"` if the backend is not temporarily disabled.


### Initialize Terraform

Run terraform init to initialize the infrastructure code.

```bash
terraform init
```

Note, if you need to undo this step remove the `.terraform` directory.

### Generate a plan

Run terraform plan to generate a terraform plan.

```bash
terraform plan -out planfile
```

### Apply changes

Run `terraform apply planfile` to create the storage bucket by applying the
planned changes.  The state file will also be written to the current working
directory.

```bash
terraform apply planfile
```

You've successfully created the GCS bucket to hold terraform state.  Click next
to move the state file to the bucket.

## Configure the Backend

You've created the GCS bucket, now you'll move the Terraform state file from
the local filesystem to the GCS bucket.

### Enable the GCS Backend

You'll need to un-comment the GCS Backend configuration now that the bucket has
been created.

Open the main.tf file in the infra/state_bucket/ directory and uncomment the
`terraform` block as in the following example.  <walkthrough-editor-open-file
filePath="infra-controller/infra/state_bucket/main.tf" text="Open
infra/state_bucket/main.tf"></walkthrough-editor-open-file>

```terraform
terraform {
  backend "gcs" {}
}
```

### Move the state file

Run `terragrunt init` to initialize the back end and move the state file into
the GCS bucket.

[Terragrunt][terragrunt] takes care of filling in the backend configuration
values for the GCS bucket using the input variables you provided at the
beginning of this walk through.  Terraform only supports static configuration
values.  Terragrunt is better suited for dynamic configuration of the GCS
backend.

```bash
terragrunt init
```

Terraform will prompt you to copy existing state to the new backend.  Enter yes
when prompted.

You should expect terragrunt to report, `"Successfully configured the backend
"gcs"!`.

### Remove local state

You'll need to disable the local state file to prevent `unexpected end of JSON
input` terragrunt errors:

```bash
mv terraform.tfstate{,.deleteme}
```

### Almost done!

Click next for final notes about using this state bucket to build the rest of
your foundational GCP infrastructure.

## Infra Controller Foundations

Congratulations, you've successfully created a GCS bucket and configured
Terraform to store state in the bucket using Terragrunt.

### Clean Up (Optional)

If you don't intend to use this state bucket, you may clean up using:

```bash
terragrunt destroy
```

### Record the bucket name

Take note of the state bucket name which will be used to build the rest of your
GCP foundations using the infra-controller repository.

The `TF_STATE_BUCKET` environment variable is used throughout the
infra-controller project.  Most enterprise customers configure one bucket for
prod and one bucket for nonprod to keep their infrastructure segmented.

Once you've fully setup your nonprod foundation using
[infra-controller][tutorial], come back to setup your production environment.

```bash
echo $TF_STATE_BUCKET
```

Continue on with the next step in the foundational infrastructure in
[tutorial walkthroughs][tutorial].

[create-project]: https://cloud.google.com/resource-manager/docs/creating-managing-projects
[new-project]: https://console.developers.google.com/projectcreate
[gcs-loc]: https://cloud.google.com/storage/docs/bucket-locations
[terragrunt]: https://github.com/gruntwork-io/terragrunt
[tutorial]: https://github.com/openinfrastructure/infra-controller/blob/master/README.md#tutorial
