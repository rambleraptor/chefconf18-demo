kubectl run chef-deployment --image gcr.io/graphite-demo-chefconf18-test/chefconf-image-prod:1.0 --port 5000
kubectl expose deployment chef-deployment --type "LoadBalancer" --type "LoadBalancer" --port 80 --target-port 5000
