#Expected outcome
Application created 
What are the addresses and functionalities ? 

#Todos
1. Adjust readmes
3. Add some load test for python app and java app
    3.2 Add singular locust containers (preferebly a job) to compare with distributed, and adjust the requests for cpu and mem values
5. Add a way to automatically create a backup of the sz-mysql databse
    5.1 Sent the backups to storage



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

Example prometheus queries:
``` 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)```- Node % cpu usage
``` sum(rate(container_cpu_usage_seconds_total{namespace="locust",container!="POD",container!=""}[5m])) by (pod) ``` - Locust cpu usage


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
* Inlfux - Vm used for monitoring of Petclinic App. Contains influx and telegraf tools installed.
* Petclinic App - Contains example java springboot application build by terra-gke 'javabuilder'. Contains Joolokia Agent 
**Note** more details on VM's and tools configuration can be found in /gcp-terraform/terra-influx/script-templates

## Important Note

The `terraform.tfstate` and `.terraform.tfstate.lock.info` files, which are typically used to store workspace states, are listed in the .gitignore file as they should not be tracked in git repository. Since the environment is temporary, the tfstate files are kept locally, and moving them to external storage was not in scope of the project. 

#### Below is a list of assumptions for project creation. 

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
    9.2 Created templates for 'on demand' load tests.
    9.3 Adjusted locust to push test results into gcp storage with initcontainer

Terra-influx:
1. Create a VM that will serve as a influx database
2. Add configuration for the influx DB to monitor itself with telegraf
3. Adjsut the configuration to automatically add new values of IP address or others based on a terraform infrastructure. (Using terraform templatefile function, with google startupscript and static external IP assigned to a VM)
4. Create a GCP storage bucket as a base for storing jar's for tomcat server.
5. Add a separate VM with petclinic app
    5.1 Get the JAR from storage and serve it externally
6. Add monitoring of JVM and VM visible in influx, of the petclinic app with telegraf + joolokia.