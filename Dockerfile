
# Python support can be specified down to the minor or micro version
# (e.g. 3.6 or 3.6.3).
# OS Support also exists for jessie & stretch (slim and full).
# See https://hub.docker.com/r/library/python/ for all supported Python
# tags from Docker Hub.
FROM centos/s2i-base-centos7
#MAINTAINER Constantin Sclifos sclifcon@ase.md
LABEL Author="Constantin Sclifos sclifcon@ase.md"

# If you prefer miniconda:
#FROM continuumio/miniconda3

LABEL Name=tehnari/oidcfed-minifed-docker Version=0.0.4
EXPOSE 8080 8100

WORKDIR /app
ADD . /app

#Adding some packages
# yum update -y && \
#RUN yum check-update && \
RUN yum install -y vim && \
    yum install -y nano && \
    yum install -y git && \
    yum install -y curl && \
    yum install -y wget && \
    yum -y install yum-utils && \
    yum -y groupinstall development && \
    yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
    yum -y install python36u && \
    yum -y install python36u-pip && \
    whereis pip3.6

# Using pip:
RUN python3.6 -m pip install --upgrade pip
RUN python3.6 -m pip install -r requirements.txt
RUN cd /app && \
    git clone https://github.com/rohe/oidc-oob-federation.git && \
    cd /app/oidc-oob-federation/ && \
    python3.6 ./create_fo_bundle.py && \
    cd /app/oidc-oob-federation/RP && \
    python3.6 ./create_sms.py conf && \
    cd /app/oidc-oob-federation/OP && \
    python3.6 ./create_sms.py conf

#CMD ["python3", "-m", "oidcfed-minifed-docker"]

# Using pipenv:
#RUN python3 -m pip install pipenv
#RUN pipenv install --ignore-pipfile
#CMD ["pipenv", "run", "python3", "-m", "oidcfed-minifed-docker"]

# Using miniconda (make sure to replace 'myenv' w/ your environment name):
#RUN conda env create -f environment.yml
#CMD /bin/bash -c "source activate myenv && python3 -m oidcfed-minifed-docker"
