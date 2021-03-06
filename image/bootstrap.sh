#!/bin/bash

metadata() {
  local -r attr=$1
  local -r metadata_ep='http://metadata/computeMetadata/v1beta1/'
  curl -H Metadata-Flavor:Google "${metadata_ep}/instance/attributes/${attr}"
}

#################################################
# Only update the following lines.
# The metadata() function is available if needed.
#################################################
declare -r chef_server="chef-server.c.graphite-demo-chefconf18-test.internal" # Chef server url
declare -r org_name="google" # Chef server org name
declare -r chef_server_crt="/opt/bootstrap/server" # GCS bucket location for server cert.
declare -r validator="/opt/bootstrap/validator" # GCS bucket location for validator cert
declare -r start_run_list="recipe[onprem::docker2]" # Runlist name
declare -r local_validator='/etc/chef/validation.pem'
declare -r startup_json='/etc/chef/startup.json'
##################################################
# DO NOT EDIT AFTER THIS
##################################################
declare -r chef_server_url="https://${chef_server}/organizations/${org_name}"

cat <<EOF
   ________         ____   _       __     __    _                     ____
  / ____/ /_  ___  / __/  | |     / /__  / /_  (_)___  ____ ______   /  _/
 / /   / __ \\/ _ \\/ /_    | | /| / / _ \\/ __ \\/ / __ \\/ __ \`/ ___/   / /
/ /___/ / / /  __/ __/    | |/ |/ /  __/ /_/ / / / / / /_/ / /     _/ /
\\____/_/ /_/\\___/_/       |__/|__/\\___/_.___/_/_/ /_/\\__,_/_/     /___/
------------------------------------------------------------------------
EOF


cat <<EOF
------------------------------------------------------------------------
chef server     : $chef_server
org name        : $org_name
chef server url : $chef_server_url
chef server crt : $chef_server_crt
validator       : $validator
start run list  : $start_run_list
local validator : $local_validator
startup json    : $startup_json
------------------------------------------------------------------------
EOF

logger -t bootstrapper 'Starting bootstrap'

if [[ -e '/usr/bin/chef-client' ]]; then
  echo '----- Chef already installed. Skipping installation. -----'
else
  echo '----- Installing Chef client -----'
  curl -L https://www.opscode.com/chef/install.sh | bash
fi

mkdir -p /etc/chef

echo '----- Copying validator key -----'
cp "${validator}" "${local_validator}"

cat >/etc/chef/client.rb <<EOF
chef_server_url '${chef_server_url}'
validation_client_name '${org_name}-validator'
EOF

echo '----- Setting up security -----'
mkdir -p /etc/chef/trusted_certs
cp "${chef_server_crt}" "/etc/chef/trusted_certs/server.crt"

echo '----- Setting first run -----'
cat >"${startup_json}" <<EOF
{"run_list": "${start_run_list}"}
EOF

echo '----- Converging Chef -----'
chef-client -j /etc/chef/startup.json 2>&1 \
  | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"

echo '----- Cleaning up -----'
echo 'Deleting validator key'
rm -f "${local_validator}"
echo 'Deleting startup role'
rm -f "${startup_json}"

# Run app

