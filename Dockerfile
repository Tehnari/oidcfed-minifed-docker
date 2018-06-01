
# Python support can be specified down to the minor or micro version
# (e.g. 3.6 or 3.6.3).
# Ex. to run this project:
# docker run -t -d -p 8080:8080 -p 8100:8100 tehnari/oidcfed-minifed-docker:0.0.5 /bin/bash
FROM opensuse/leap
#MAINTAINER Constantin Sclifos sclifcon@ase.md
LABEL Author="Constantin Sclifos sclifcon@ase.md"

# If you prefer miniconda:
#FROM continuumio/miniconda3

LABEL Name=tehnari/oidcfed-minifed-docker Version=0.0.6
EXPOSE 8080 8100

WORKDIR /app
ADD . /app

#Adding some packages
RUN zypper -v ref && zypper -n in -l vim  nano git curl wget python3 python3-pip && \
    whereis pip3

# Using pip:
#RUN PATH=$HOME/.local/bin:$HOME/.local/lib:$HOME/.local/lib/python3.6:$HOME/.local/lib/python3.6/site-packages:$PATH
RUN python3.6 -m pip install --upgrade pip
#RUN python3.6 -m pip install  --user -r requirements.txt
RUN python3.6 -m pip install  -r requirements.txt
#RUN python3.6 -m pip install --force-reinstall --no-cache-dir -r requirements.txt
RUN cd /app && \
    git clone https://github.com/rohe/oidc-oob-federation.git && \
    cd /app/oidc-oob-federation/ && \
    python3.6 ./create_fo_bundle.py && \
    cd /app/oidc-oob-federation/RP && \
    python3.6 ./create_sms.py conf && \
    cd /app/oidc-oob-federation/OP
#    cd /app/oidc-oob-federation/OP && \
#    python3.6 ./create_sms.py conf


#CMD ["python3", "-m", "oidcfed-minifed-docker"]

# Using pipenv:
#RUN python3 -m pip install pipenv
#RUN pipenv install --ignore-pipfile
#CMD ["pipenv", "run", "python3", "-m", "oidcfed-minifed-docker"]

# Using miniconda (make sure to replace 'myenv' w/ your environment name):
#RUN conda env create -f environment.yml
#CMD /bin/bash -c "source activate myenv && python3 -m oidcfed-minifed-docker"
