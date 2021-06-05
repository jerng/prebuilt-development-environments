FROM ubuntu:latest 
  # 14.04.1 tested 

MAINTAINER Yang Jerng HWA
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/

RUN apt-get update &&\
    apt-get install -y software-properties-common

RUN add-apt-repository ppa:staticfloat/juliareleases && \
    add-apt-repository ppa:staticfloat/julia-deps && \
    apt-get update && \
    apt-get install -y julia
