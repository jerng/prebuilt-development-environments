FROM debian:latest 
  # 7.7 tested 

MAINTAINER Yang Jerng HWA
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/

RUN apt-get update && apt-get install -y wget

RUN wget http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_1_general/esl-erlang_17.3-2~debian~wheezy_amd64.deb && \
    dpkg -i --force-depends esl-erlang_17.3-2~debian~wheezy_amd64.deb &&\
    rm esl-erlang_17.3-2~debian~wheezy_amd64.deb &&\
    apt-get -fy install

      # The final line tries to fix dependency issues.
