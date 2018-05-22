#
# Cookbook:: onprem
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Get yum epel-library
package 'epel-release'

# Install OS dependencies
python_runtime '2'
package 'git'

# Clone app
git "/opt/app" do
  repository "https://github.com/rambleraptor/flask-app.git"
  branch "background"
end

# Install Pip manually because poise-python doesn't seem to
bash 'get pip install script' do
  code 'curl https://bootstrap.pypa.io/get-pip.py -o /opt/bootstrap/get-pip.py'
end

bash 'install pip' do
  code 'python /opt/bootstrap/get-pip.py'
end

# Install dependencies manually because poise-python resource doesn't seem to
bash 'install requirements' do
  code "pip install -r /opt/app/requirements.txt"
end
