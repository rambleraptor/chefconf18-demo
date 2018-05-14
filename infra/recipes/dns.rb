raise "Missing parameter 'CRED_PATH'. Please read docs at #{__FILE__}" \
  unless ENV.key?('CRED_PATH')

gauth_credential 'mycred' do
  action :serviceaccount
  path ENV['CRED_PATH'] # e.g. '/path/to/my_account.json'
  scopes [
    'https://www.googleapis.com/auth/ndev.clouddns.readwrite'
  ]
end

gdns_managed_zone 'chefconf-zone' do
  action :create
  dns_name 'app.cloudgraphite.rocks.'
  description 'ChefConf app'
  project 'graphite-demo-chefconf18-test'
  credential 'mycred'
end

gdns_resource_record_set 'www.app.cloudgraphite.rocks.' do
  action :create
  managed_zone 'chefconf-zone'
  type 'A'
  ttl 600
  target [
    # Use Kubectl to find the DNS endpoint for the service
    `kubectl describe service chef-deployment | grep "LoadBalancer Ingress" | awk '{print $3}' | tr -d '\n'`
  ]
  project 'graphite-demo-chefconf18-test'
  credential 'mycred'
end
