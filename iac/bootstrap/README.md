# Bootstrap

## Prerequisites

- GCloud SDK

## Bootstrap guide

- Get logged in via `gcloud`:

```bash
gcloud init
gcloud auth application-default login
```

- Make sure that you have the correct GCP project set:

```bash
gcloud config get project
```

- If not, set the correct GCP project id:

```bash
gcloud config set project PROJECT_ID
```

- Create bootstrap resources:

  - If you are running these steps for a new environment, delete the
    backend.tf file before proceeding.

  - Run `terraform init` and then `terraform plan` using the needed `.tfvars`
    from `environments` folder selecting the  file associated with the targeted
    environment (`dev`,`prd`) to check which resources will be
    created. (should be the creation of the terraform state bucket, terraform
    service account, IAM permissions for the service account, enabled services
    APIs)

```bash
terraform init
```

```bash
export ENV=<environment_name> # e.g.: export ENV=dev
terraform plan --var-file environments/$ENV/$ENV.tfvars -out deploy.plan
```

- Run `terraform apply deploy.plan` if the above plan looks good and confirm
  with `yes`

- Take a note on the output `service_account` and `state\bucket` of the apply
  and save the output somewhere

- Once the resources have been created, copy `backend.tf-example` file to
  `backend.tf` and set the bucket to the value of `state\bucket\name` from the
  terraform apply output

- Run again `terraform init` specifying the `config.gcs.tfbackend` file
  related to the targeted environment which will ask if you want to copy the
  local Terraform state into the remote state bucket - confirm by typing `yes`

```bash
terraform init -backend-config=environments/$ENV/config.gcs.tfbackend
```

- Remove `terraform.tfstate` and `terraform.tfstate.backup` files from your
  local drive. Run another terraform apply which should no longer need to
  create any new resources

## Adding/changing/removing resources on Bootstrap Terraform code

At this point, the project bootstrap process finished and `terraform.tfstate`
configuration is stored into a remote GCS bucket
(`$ENV-terraform-deploy-state`). If you need to make changes on the
bootstrap code you will need to:

- Make sure that `backend.tf` file has the same content with
  backend.tf-example
- Initialize the terraform code:

 ```bash
terraform init -backend-config=environments/$ENV/config.gcs.tfbackend
```

- Add desired changes and run:

```bash
terraform plan --var-file environments/$ENV/$ENV.tfvars -out deploy.plan
```

- If the plan looks as expected you can run it against the environment:

```bash
terraform apply --var-file environments/$ENV/$ENV.tfvars deploy.plan
```
