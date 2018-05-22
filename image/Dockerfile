FROM centos:latest
ADD . /opt/bootstrap
EXPOSE 5000
EXPOSE 80
EXPOSE 443

# Install dependencies
RUN yum -y update
RUN yum install -y curl
RUN chmod +x /opt/bootstrap/bootstrap.sh
RUN /opt/bootstrap/bootstrap.sh

ENTRYPOINT FLASK_APP=/opt/app/app.py flask run --host=0.0.0.0
