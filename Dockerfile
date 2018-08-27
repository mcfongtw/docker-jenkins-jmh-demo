FROM jenkins/jenkins:lts


MAINTAINER Michael Fong <mcfong.open@gmail.com>

USER root

RUN apt-get update && apt-get install -y gcc g++ build-essentials

USER jenkins

