FROM centos:latest
ADD . /opt/bootstrap
EXPOSE 5000
EXPOSE 80
EXPOSE 443

# Install dependencies
RUN yum -y update
RUN yum install -y curl
RUN chmod +x /opt/bootstrap/bootstrap.sh

ENTRYPOINT /opt/bootstrap/bootstrap.sh

