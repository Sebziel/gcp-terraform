Application requires docker and kubernetes environment. (Tested with Minikube + Docker 20.10.21)
For simple application tests, it's better to use different branch, as some pre-requisites are necessary.

To apply code changes in the app run:
1. run "docker build -t 2435292/funkyflask:latest ."
2. check the docker image by "doker images"
3. push the image to dockerhub by "docker push 2435292/funkyflask:latest"

Since the application logging is set to use kubernetes volumeclaim which is hard coded it's required to run in kuberentes environment.
As an alternative to run locally in docker the "logging.basicConfig" filename location have to be changed.

deployment.yaml contains all the kubernetes configuration that is required, the deployment also consists of Filebeat and elasticsearch, hopefully to be configured in the future. 
