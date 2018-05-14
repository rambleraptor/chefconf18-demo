# ChefConf 2018 Presentation
Chef + Google Kubernetes Engine

# Cookbooks
This repo contains two playbooks and a folder with a Docker image.

# onprem
This cookbook contains instructions to deploy a Python Flask app. It contains two recipes:

* default: installs Python, Flask, Gunicorn + Nginx. Deploys Nginx as a service.
* docker: installs just Python + Flask and runs Flask directly. This is meant to be used on a Docker container as part of a Kubernetes installation.

# image
This contains all of the information necessary to create a Docker image that will connect to a Chef server. You will need to provide a server cert, a validation cert, and change some of the variables in the bootstrap.sh script.

# infra
This cookbook contains the chef scripts to setup the GKE infrastructure. It contains two recipes:

* default: Setups a GKE cluster and creates a kubectl config file to make changes to the cluster using the kubectl CLI.
* dns: Creates DNS entries for the cluster.
