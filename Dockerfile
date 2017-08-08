FROM ruby:2.3.1

MAINTAINER Codaisseur <oss@codaisseur.com>

RUN curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
  && apt-get install -yq \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    libqt4-webkit \
    libqt4-dev \
    xvfb \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    yarn \
  && rm -rf /var/lib/apt/lists/*

# See http://nodejs.org/dist/npm-versions.txt
# for valid node versions

ENV NODE_VERSION v7.6.0

# install nodejs
RUN cd /tmp && \
  wget http://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz && \
  tar xvzf node-${NODE_VERSION}.tar.gz && \
  rm -f node-${NODE_VERSION}.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

# install awscli
RUN pip install awscli

WORKDIR /app
ONBUILD ADD . /app

CMD ["bash"]
