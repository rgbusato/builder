FROM ubuntu:16.04
#FROM ubuntu:18.04

# set variables
ARG docker_compose_version="1.21.0"
ARG packer_version="1.2.4"
ARG terraform_version="0.11.7"

ENV DOCKER_COMPOSE_VERSION $docker_compose_version
ENV PACKER_VERSION $packer_version
ENV TERRAFORM_VERSION $terraform_version

WORKDIR /code

# update and install common packages
RUN set +x \
  && env \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install \
     python3-minimal \
     python3-pip \
     jq \
     git \
     groff \
     unzip \
     wget

# update and install Docker CE and associated packages
#&& add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/debian \
#    $(lsb_release -cs) \
#    stable" \

RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic edge" > /etc/apt/sources.list.d/docker.list
RUN set +x \
  && apt-get install -y \
     lsb-release \
     software-properties-common \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
  && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y docker-ce \
  && systemctl enable docker

# install docker-compose


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

