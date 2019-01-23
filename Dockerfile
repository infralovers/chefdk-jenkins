ARG SLAVE_VERSION=3.27-1
FROM jenkins/slave:${SLAVE_VERSION}

ARG CHANNEL=stable
ARG CHEF_VERSION=3.6.57
ARG USER=jenkins
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV DEBIAN_FRONTEND=noninteractive \
  PATH=/opt/chefdk/bin:/opt/chefdk/embedded/bin:/root/.chefdk/gem/ruby/2.5.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# prereqs
USER root
RUN apt-get update && \
  apt-get install -y gpg-agent \
  apt-transport-https \
  ca-certificates \
  curl software-properties-common \
  wget \
  openssh-client
# install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
  apt-get update && \
  apt-get install -y docker-ce lsb-release

# https://packages.chef.io/files/stable/chefdk/3.6.57/debian/9/chefdk_3.6.57-1_amd64.deb
RUN wget --quiet --content-disposition "http://packages.chef.io/files/${CHANNEL}/chefdk/${CHEF_VERSION}/$(lsb_release -is | awk '{print tolower($0)}')/$(lsb_release -rs | awk -F'.' '{print $1}')/chefdk_${CHEF_VERSION}-1_amd64.deb" -O /tmp/chefdk.deb && \
  dpkg -i /tmp/chefdk.deb && \
  chef gem install kitchen-docker && \
  chef gem install kitchen-openstack && \
  chef gem install knife-openstack && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  groupmod -g ${GROUP_ID} jenkins && \
  usermod -u ${USER_ID} -g ${GROUP_ID} ${USER} && \
  adduser ${USER} docker


USER jenkins
VOLUME /var/run/docker.sock
