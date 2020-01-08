FROM jenkins/jenkins:lts

MAINTAINER Michael Fong <mcfong.open@gmail.com>

#######################################################
# Init Installation
ENV JENKINS_USER admin
ENV JENKINS_PASS admin

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

#######################################################
# Pre-install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
#######################################################

USER root

#######################################################
# Docker
RUN apt-get update \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
    && apt-get install docker-ce -y
RUN usermod -aG docker jenkins
RUN apt-get clean
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

#######################################################

WORKDIR /var/jenkins_home

USER jenkins

# jenkins home dir
VOLUME /var/jenkins_home

# git repo dir
VOLUME /home/git.repo

EXPOSE 8080

EXPOSE 50000

