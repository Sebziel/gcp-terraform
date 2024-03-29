# Project Title

This is a Terraform project consisting of two primary sub-projects: `terra-arti` and `terra-gke`.

## Manual changes required for project:

1.Change the terraform.tfvars project attribute to current gcp project
2. Change the image to reflect the current gcp project id in /k8s/* deployments

## Usefull commands:

In order to setup kubectl against the cluster run:

```gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)```

## Sub-Project: terra-arti 

This sub-project contains the definitions for Google's Artifact Registry resources and builds the image of the "PythonDB" projects, as well as the mySQL image.
You will find shell scripts to activate APIs (`activateApis.sh`) and to build images (`build_image.sh`).

The main Terraform script is `main.tf` and there is also a variables file named `manualvars.tf`. It includes a PythonDB project with its own `Dockerfile` and Python scripts. The specific descriptions and usages of PythonDB project are given separately in its own `readme.md` file located in the PythonDB directory.

A mySQL database image is included in the `sz_mysql_image` directory, defined within its own `Dockerfile`.

## Sub-Project: terra-gke

This sub-project contains the definitions for the Google Kubernetes Engine (GKE) cluster. The main Terraform script here is `gke.tf`, with complementary scripts for output (`outputs.tf`), versioning (`versions.tf`), and VPC configuration (`vpc.tf`).

The Terraform state for the GKE is kept in `terraform.tfstate`, and a variables file can be found as `terraform.tfvars` for any environment-specific configurations.

## Important Note

The `terraform.tfstate` and `.terraform.tfstate.lock.info` files, which are typically used to store workspace states, are listed in the .gitignore file as they should not be tracked in git repository.

Please dive into each sub-project and run the Terraform scripts as per your requirements.

