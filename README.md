# Translation Service

## Project Overview

This project comprises of two microservices.

1. A Flask API microservice which take a `word` of any language and translates to english.

2. `translation` db. The Microservice gets a little intelligent by not calling the Google Translate API everytime because there is a stateful db attached to it called `translation` which maintains a relational table called `transaltor`. So if an encountered word comes in a POST call in the microservice, It gets retrieved from `translation` db.

### Project Components

1. Docker images
   - `kabalasu/my_postgres` - translation db
   - `kabalasu/translator` - Translation API microservice
2. Jenkins for CI/CD
3. Kubernetes for Container orchestration
4. Ansible Playbook for orchestration deployment
5. Makefile for dev environment setup

The end user should need expertise in python, shell, basics of Kubernetes and Ansible to
get the most out of this project.

### Project setup

#### Dev

prerequisite - Docker and python

```
make setup
make install
make db-build
make db-dev
make app-build
make app
sh examples/translate.sh 127.0.0.1 8000 "hola"
```

### AWS setup

Amazon EC2 T3 Xlarge with 25 GB of EBS (customized). Make sure you dont run this all day.

### Jenkins in AWS setup

Please follow `Installing Jenkins` notes in Udacity Devops Nanodegree Program Chapter 4 Build CI/CD Pipelines, Monitoring & Logging - Lesson 1 Continuous Integration and Continuous Deployment - Lecture 10 Installing Jenkins

### Kubernetes

Prerequisites Docker

1. Enter as Jenkins user
2. Add Jenkins user to Docker group
3. Use Minikube installation of Docker

### Ansible

1. On jenkins instance install ansible - follow the steps here - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
2. copy the codebase in Jenkins home.
3. chown Jenkins user to execute kubernetes scripts in the codebase.
4. A very simple implementation of running Kubernetes to localhost with minikube
   implementation is found here - https://github.com/karthikBalasubramanian/cloud-devops-ansible

### Kubernetes Cluster on AWS cloud

on Aws jenkins ec2 instance as Jenkins user execute this command

```
minikube tunnel
```

you will get an output like this

```
status:
        machine: minikube
        pid: 65941
        route: 10.96.0.0/12 -> 172.17.0.3
        minikube: Running
        services: [translator-service]
    errors:
                minikube: no errors
                router: no errors
                loadbalancer emulator: no errors
```

where `172.17.0.3` is your exposed node IP

Next step is to get the LoadBalancer Port address and query the translator api.

```
jenkins@ip-172-31-10-207:~$ kubectl get svc -o wide
NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)          AGE   SELECTOR
kubernetes           ClusterIP      10.96.0.1       <none>         443/TCP          35m   <none>
postgres-service     NodePort       10.109.228.84   <none>         5432:31376/TCP   35m   app=postgres
translator-service   LoadBalancer   10.96.111.45    10.96.111.45   80:30121/TCP     34m   app=translator
jenkins@ip-172-31-10-207:~$ curl "http://172.17.0.3:30121"
<h3>Translate App</h3>jenkins@ip-172-31-10-207:~$ sh ~/cloud-devops-project/examples/translate.sh 172.17.0.3 30121 "hola"
{
  "result": {
    "origin": "hola",
    "origin_language": "es",
    "translated_from": "google_api",
    "translation": "Hello",
    "translation_language": "en"
  }
}
jenkins@ip-172-31-10-207:~$ sh ~/cloud-devops-project/examples/translate.sh 172.17.0.3 30121 "hola"
{
  "result": [
    {
      "origin": "hola",
      "origin_language": "es",
      "translated_from": "translator_db",
      "translation": "Hello",
      "translation_language": "en"
    }
  ]
}
```

please find all the screenshots in `screenshots` folder.
