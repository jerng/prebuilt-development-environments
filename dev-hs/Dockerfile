FROM ubuntu:latest 
  # 14.04.1 tested

MAINTAINER Yang Jerng HWA
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/

RUN apt-get update && apt-get install -y wget
RUN wget -O - http://www.haskell.org/platform/download/2014.2.0.0/haskell-platform-2014.2.0.0-unknown-linux-x86_64.tar.gz | tar xzf - -C /
  # 2014.2.0.0 changelog: https://www.haskell.org/platform/changelog.html

  # Alternatively, try installing from source!
  # Or try this: https://github.com/darinmorrison/docker-haskell/tree/docker-library

RUN apt-get install -y libgmp-dev 
RUN /usr/local/haskell/ghc-7.8.3-x86_64/bin/activate-hs
