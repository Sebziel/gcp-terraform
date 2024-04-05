## Usefull commands:

Default run:

Setup local variable for gcloud token: 
```export TF_VAR_gcloud_token=$(gcloud auth print-access-token)```

initialize terraform from gcp-terraform main catalog:
```terraform init```

In order to setup kubectl against the cluster run:
```gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)```

Apply k8s-manifests
``` cd /gcp-terraform/modules/terra-gke/k8s-manifests```

#Todos

1. Add some instructions on image rebuilding, with taint and terraform state to usefull commands 
2. Change javabuilder pod to job so it will terminate after finish
3. Add a separate VM with petclinic app
    3.1 Get the JAR from storage and serve it from tomcat
4. Configure telegraf to handle the petclinic and feed to influxdb VM
5. Add a way to automatically create a backup of the sz-mysql databse
    5.1 Sent the backups to storage

#Done

Terra-Arti:
1. Create a IAAC for GCP Artifactory registry
2. Create a process for building and pushing docker images with user-defined list of images to the artifactory
3. Create a customized my-sql image that will serve as database
    3.1 Add some initial data to the app.
4. Create an dockerized Python app that will load random data into the database
    4.1 make sure it will be possible to define the amount of data to be loaded.
5. Create an dockerized python app that will serve as an API to retrieve the data from the database.
6. Create a frontend application with python flask, add it as a docker image. 
7. Add a utility image for testing purposes.
8. Add the image to build petclinic app
    8.1 Add a possibility to create a pods with access to GCP storage - Because of "A cloud Guru's" limatation on access to IAM recoomended approach of using GKE workload identity federation was not possible. Hence, since the environemnt is temporary by default (4h) The authorization token is passed from the cloud shell that triggers the terraform build.
    8.2 Push the created JAR file to storage

Terra-gke:
1. Create a GKE cluster with a user-defined number of nodes
 1.2 Add some outputs to partially automate getting the credentials
2. Add a way to pull the images created in terra-arti module
3. Create k8s manifests to create deployment of mysql database, add a service so the app will be accesible from within cluster only
4. Create k8s manifests to deploy the frontend app, add a load-balancer service so the app will be accesible for public.
5. Automate the k8s manifests modifications to ajudst the project-id changes with terraform templates.
6. Add a way to distribute a significant load from the data generator evenly across the nodes in a efficient mannor as a kubernetes job object.

Terra-influx:
1. Create a VM that will serve as a influx database
2. Add configuration for the influx DB to monitor itself with telegraf
3. Adjsut the configuration to automatically add new values of IP address or others based on a terraform infrastructure. (Using terraform templatefile function, with google startupscript and static external IP assigned to a VM)
4. Create a GCP storage bucket as a base for storing jar's for tomcat server.

# GCP + Terraform training

This is a Terraform project consisting of two primary sub-projects: `terra-arti` and `terra-gke`.

## Manual changes required for project:

1.Change the terraform.tfvars project attribute to current gcp project
2. Change the image to reflect the current gcp project id in /k8s/* deployments

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

