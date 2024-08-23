#Todos
# GCP + Terraform training

This is a Terraform project consisting of three primary sub-projects: `terra-arti`, `terra-gke` and `terra-influx`.
Project is designed to be run on a temporary GCP account provided by ACG. Hence multiple constraints have been faced and not all best practices implemented.

**Note** Because of the training nature of the project, not all solutions are efficient or following best practices. In some cases, work-arounds were used just to work with different architecture or tools. Example would be including DB passwords directly in dockerfiles or adding gcloud authorization token into k8s manifests. Taking into consideration the temporary environment the risk is limited. It would require further work though.

## Basic usage:

Change the google project id in root directory - terraform.tfvars file.

Setup local variable for gcloud token: 
```export TF_VAR_gcloud_token=$(gcloud auth print-access-token)```

initialize terraform from gcp-terraform main catalog and apply infrastructure:
```terraform init``` & ```terraform apply```

(Optionally) In order to setup kubectl against the cluster run:
```gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)```

## Sub-Project: terra-arti 

The purpose of the module is to create a GCP artifactory, build docker images and push them into a created artifactory.

This sub-project contains the definitions for Google's Artifact Registry resources in terraform. It builds and pushes the images using shell scripts and terraform local resources. Images are specified in image_list variable (defined in terraform.tfvars). Each dockerfile for image and required files should be placed in /modules/terra-arti/{image_name}.

Most of the images managed by the terra-arti module have their own readme files in their directories, containing more details on particular image and it's usage.

In the module you will also find shell scripts to activate GCP APIs (`activateApis.sh`) and to build images (`build_image.sh`).

### Expected outcome 

Artifact repository created. 
Multiple docker images build and pushed to created repository. 

## Sub-Project: terra-gke

The purpose of the project is to manage k8s cluster and manifests.

This sub-project contains the definitions for the Google Kubernetes Engine (GKE) cluster. The main Terraform script here is `gke.tf`, with complementary scripts for output (`outputs.tf`) and VPC configuration (`vpc.tf`). The amount of nodes per zone might be adjusted and is defined in terraform.tfvars 'gke_num_nodes'. Keep in mind the ACG limits of 10 vcpu's.

In order to setup kubectl against the cluster run:
```gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)```

The terra-gke project also generates k8s manifests to (gcp-terraform/modules/terra-gke/k8s-manifests), that later on have to be deployed to kubernetes cluster.

Example prometheus queries:
``` 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)```- Node % cpu usage
``` sum(rate(container_cpu_usage_seconds_total{namespace="locust",container!="POD",container!=""}[5m])) by (pod) ``` - Locust cpu usage

### Expected outcome
Kubernetes manifests created in gcp-terraform/modules/terra-gke/k8s-manifests.
Applying the manifests should result in:

* 'Funky flask app' up and running a simple http flask application
* 'FlaskDb App' a basic api that query the DB for user details.
* 'JavaBuilder' a container which performs the build of spring petclinic app and uploads it to storage bucket.
* 'pythondb-job' a kubernetes cronjob that loads randomly generated users data to the database, allowing to do that with multiple pods in parallel 
* 'prometheus' Monitoring tool for kubernetes cluster - available with ip of loadbalancer in prometheus namespace
* 'locust' Python based load test tool - avaliable in two modes (/gcp-terraform/modules/terra-gke/k8s-manifests/locust.yaml) with ip of loadbalancer in locust namespace


**Note** Running ```kubectl get services``` will provide with the IP's of loadbalancers which can be accessed to see the outcome. (Prometheus and locust are available in separate namespaces)

```
kubectl get services
NAME                             TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)        AGE
kubernetes                       ClusterIP      34.118.224.1     <none>          443/TCP        153m
load-balancer                    LoadBalancer   34.118.239.253   *34.31.12.41*     80:31971/TCP   5m15s
load-balancer-databaseflaskapp   LoadBalancer   34.118.231.142   *34.28.164.170*   80:32593/TCP   5m14s
sz-mysql-service                 ClusterIP      34.118.229.3     <none>          3306/TCP       5m14s
```
Based on above example accesing 
* ```34.31.12.41:80``` should grant access to 'funky flask app' a simple http flask application.
* ```34.28.164.170:80``` should grant access to basic flask-based api that queries the database. Two endpoint are available:
 * /api/getUsers - that lists all the users in json format. Allows to limit the number of requested users with count parameter. e.g. ```http://34.28.164.170/api/getUsers?count=10``` will display 10 users.
 * /api/findUser - Finds a user with a 3 letters of a name or surname. e.g. ```http://34.28.164.170/api/findUser?firstname=Kristen``` will display all users with 'Kirsten' as a first name.


**Note on locust** There are two ways to use locust in this project :
* By running a job defined in k8s-manifests/locust.yaml - It uses a headless mode and pushes the results to storage bucket
* By accessing locust UI (k8s svc 'locust-load-balancer') and triggering tests manually

## Sub-Project: terra-influx

The purpose of the project is to manage influx and petclinic 

Two VM's are created, the startup scripts are generated and adjusted by terraform.
* Inlfux:
    * Vm used for monitoring of Petclinic App.
    * Contains influx and telegraf tools installed.
    * Available at {influx-instance-external-ip}:8086 with default password set to admin/nimda2024
    * Data from petclinic app and influxvm itself is available in data-explorer/training-bucket.
* Petclinic App:
    * Contains example java springboot application build by terra-gke 'javabuilder'.
    * Contains Joolokia Agent for jvm monitoring - Data available in influxvm. 

**Note** more details on VM's and tools configuration can be found in /gcp-terraform/terra-influx/script-templates

#### Important Note

The `terraform.tfstate` and `.terraform.tfstate.lock.info` files, which are typically used to store workspace states, are listed in the .gitignore file as they should not be tracked in git repository. Since the environment is temporary, the tfstate files are kept locally, and moving them to external storage was not in scope of the project. 