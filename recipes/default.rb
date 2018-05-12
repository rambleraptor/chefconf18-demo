#
# Cookbook:: onprem
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Install OS dependencies
python_runtime '2'
package 'git'
package 'nginx'

# Clone app
git "/opt/app" do
  repository "https://github.com/rambleraptor/flask-app.git"
end

# Install dependencies into virtualenv
python_virtualenv '/opt/app/flaskenv'
pip_requirements "/opt/app/requirements.txt" do
  virtualenv "/opt/app/flaskenv"
end

# Start Gunicorn service
template '/etc/systemd/system/flask.service' do
  source 'service.erb'
end

service 'flask' do
  action :start
end

# Start nginx
template '/etc/nginx/nginx.conf' do
  source 'nginx.erb'
end

service 'nginx' do
  action :restart
end
