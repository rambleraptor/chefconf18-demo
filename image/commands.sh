gcloud auth configure-docker
docker build -t chef-image .
docker tag chef-image gcr.io/graphite-demo-chefconf18-test/chefconf-image:0.1
docker push gcr.io/graphite-demo-chefconf18-test/chefconf-image:0.1

