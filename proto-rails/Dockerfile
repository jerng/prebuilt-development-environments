FROM ubuntu:14.04

MAINTAINER Yang Jerng HWA

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/

# Prepare certain Debian packages

RUN rm -f /etc/apt/sources.list.d/proposed.list

RUN apt-get update \
    && apt-get upgrade -y

RUN apt-get install -y \
    curl git vim \
    build-essential libssl-dev \
    mysql-server-5.6 libmysqlclient-dev libsqlite3-dev \
    libreadline-dev

RUN echo '\nservice mysql start' >> ~/.bashrc

RUN git config --global user.email "" \
    &&     git config --global user.name "" \
    &&     git config --global credential.helper "cache --timeout=604800"

# Prepare the Ruby intepreter

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN /bin/bash -ci 'rbenv install 2.4.0 --verbose && rbenv global 2.4.0'

# Prepare the NodeJS framework

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

RUN /bin/bash -ci 'nvm install v10.16.0; exit 0' 
    # 'exit 0' is to ignore a warning message emited by the installer

RUN echo '\nnvm use v10.16.0' >> ~/.bashrc

RUN echo '\nnvm use --delete-prefix v10.16.0' >> ~/.bashrc

# Import Gemfile to proto-rails app folder, build the toy Rails app

RUN /bin/bash -ci 'gem install bundler -v 1.11.2 && gem install rails -v 5.2.3 '

COPY folder-copied-into-image /proto-rails

RUN /bin/bash -ci 'cd /proto-rails \
    && rails new --skip-gemfile . \
    && bundle install'

# Setting the entry point 

CMD /bin/bash -ci 'cd /proto-rails \
    && rails s -b 0.0.0.0'
