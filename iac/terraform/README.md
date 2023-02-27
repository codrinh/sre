# Bootstrap

## Prerequisites

- GCloud SDK
- update the `environments\<env>\config.gcs.tfbackend` with the GCP bucket from the bootstrap output
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

- Set the environement

```bash
export ENV=<environment_name> # e.g.: export ENV=dev
```

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
