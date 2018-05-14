gcloud auth configure-docker
docker build -t chef-image .
docker tag chef-image gcr.io/graphite-demo-chefconf18-test/chefconf-image:1.0
docker push gcr.io/graphite-demo-chefconf18-test/chefconf-image:1.0

