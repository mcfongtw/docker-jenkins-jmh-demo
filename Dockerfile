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
# SDKMan

# Prerequisites
RUN apt-get update && apt-get install -y g++
RUN apt-get update && apt-get install -y curl wget unzip zip

####################################################### 
RUN apt-get update && \
        apt-get install -y zip unzip;

RUN curl -s "https://get.sdkman.io" | bash
ENV SDKMAN_DIR /root/.sdkman/
RUN set -x \
    && echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config \
    && echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config \
    && echo "sdkman_insecure_ssl=false" >> $SDKMAN_DIR/etc/config

# Maven
RUN /bin/bash -c " source $SDKMAN_DIR/bin/sdkman-init.sh && sdk install maven"

RUN chown -R jenkins:jenkins $SDKMAN_DIR
#######################################################

WORKDIR /var/jenkins_home

USER jenkins

VOLUME /var/jenkins_home

EXPOSE 8080

EXPOSE 50000

