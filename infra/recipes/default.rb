raise "Missing parameter 'CRED_PATH'. Please read docs at #{__FILE__}" \
  unless ENV.key?('CRED_PATH')
 
gauth_credential 'mycred' do
  action :serviceaccount
  path ENV['CRED_PATH'] # e.g. '/path/to/my_account.json'
  scopes [
    'https://www.googleapis.com/auth/cloud-platform'
  ]
end
 
gcontainer_cluster "mycluster" do
  action :create
  initial_node_count 3
  node_config(
    machine_type: 'n1-standard-4', # we want 4-cores for our cluster
    disk_size_gb: 500,              # ... and a lot of disk space
    oauth_scopes: [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  )
  zone 'us-central1-a'
  project 'graphite-demo-chefconf18-test'
  credential 'mycred'
end
 
directory '/home/alexstephen/.kube' do
  action :create
end
 
gcontainer_kubeconfig '/home/alexstephen/.kube/config' do
  action :create
  cluster "mycluster"
  zone 'us-central1-a'
  project 'graphite-demo-chefconf18-test'
  credential 'mycred'
end
