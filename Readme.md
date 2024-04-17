## Usefull commands:

Default run:

Setup local variable for gcloud token: 
```export TF_VAR_gcloud_token=$(gcloud auth print-access-token)```

initialize terraform from gcp-terraform main catalog:
```terraform init```

apply infrastructure:
```terraform apply```

In order to setup kubectl against the cluster run:
```gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)```

usefull prometheus queries:
``` 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)```- Node % cpu usage
``` sum(rate(container_cpu_usage_seconds_total{namespace="locust",container!="POD",container!=""}[5m])) by (pod) ``` - Locust cpu usage

#Todos
1. Adjust readmes
3. Add some load test for python app and java app
    3.1 Add distrubuted locust for simulation of higher loads
    3.2 Add singular locust containers (preferebly a job) to compare with distributed, and adjust the requests for cpu and mem values
    3.3 Pass the results of the tests to a storage
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
7. Change javabuilder pod to job so it will terminate after finish
8. Add tools to provide visibility of the cluster resources state - Done with prometheus and nodeexpoerter.
9. Add load testing tool (locust)
    9.1 Since locust supports two 'modes' with gui and with cli, I used both. IN K8s manifests, there's a locust.yaml which run's in headless mode (Todo - pass the results to gcp storage) in locust folder there's a deployment of master-follower architecture designed for more intense workloads as the followers might be scaled up if more simulated users are required.

Terra-influx:
1. Create a VM that will serve as a influx database
2. Add configuration for the influx DB to monitor itself with telegraf
3. Adjsut the configuration to automatically add new values of IP address or others based on a terraform infrastructure. (Using terraform templatefile function, with google startupscript and static external IP assigned to a VM)
4. Create a GCP storage bucket as a base for storing jar's for tomcat server.
5. Add a separate VM with petclinic app
    5.1 Get the JAR from storage and serve it externally
6. Add monitoring of JVM and VM visible in influx, of the petclinic app with telegraf + joolokia.

# GCP + Terraform training

This is a Terraform project consisting of two primary sub-projects: `terra-arti` and `terra-gke`.

## Manual changes required for project:

1.Change the terraform.tfvars project attribute to current gcp project
2.Run below command to set up the gcloud auth key: 

```export TF_VAR_gcloud_token=$(gcloud auth print-access-token)```

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

