FROM ubuntu:18.04
#FROM python:3.5

# set variables
ARG packer_version="1.2.4"
ARG terraform_version="0.11.7"

ENV PACKER_VERSION $packer_version
ENV TERRAFORM_VERSION $terraform_version

WORKDIR /code

#RUN apt-get update && apt-get install -y \
#  python3-minimal \
#  python3-pip \
#  terraform \
#  packer

# update and install common packages
RUN set +x \
  && env \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install \
     openrc \
     openntpd \
     tzdata \
     python3-minimal \
     python3-pip \
     jq \
     git

# update and install Docker CE and associated packages
RUN set +x \
  && apt-get install -y \
     lsb-release software-properties-common \
     apt-transport-https ca-certificates curl gnupg2 \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
  && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y docker-ce \
  && systemctl enable docker

# Install HasiCorp Packer
RUN set +x \
  && wget "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
  && unzip packer_${PACKER_VERSION}_linux_amd64.zip \
  && rm -rf packer_${PACKER_VERSION}_linux_amd64.zip \
  && mv packer /bin

# Install HasiCorp Terraform
RUN set +x \
  && wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /bin

COPY ./requirements.txt /code/
RUN pip3 install -r requirements.txt

