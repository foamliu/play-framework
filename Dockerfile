FROM centos:7
MAINTAINER Foam Liu <foamliu@yeah.net>

RUN yum update && \
    yum install -y git build-essential curl wget zip unzip software-properties-common