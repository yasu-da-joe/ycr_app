FROM ruby:3.2.3

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

# Node.jsとYarnのインストール（特定のバージョンを指定）
ENV NODE_VERSION=20.9.0
ENV YARN_VERSION=1.22.19

RUN apt-get update -qq && \
    apt-get install -y ca-certificates curl gnupg build-essential libpq-dev vim && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update -qq && \
    apt-get install -y nodejs=${NODE_VERSION}* && \
    npm install -g yarn@${YARN_VERSION} nodemon esbuild sass

RUN mkdir /myapp
WORKDIR /myapp

RUN gem install bundler

# package.jsonとyarn.lockをコピーして依存関係をインストール
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Gemfileをコピーして依存関係をインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションのソースコードをコピー
COPY . /myapp

# 依存関係が正しくインストールされたか確認
RUN yarn install

# Node.js、Yarn、依存関係のバージョンを確認
RUN node --version && yarn --version && yarn list --depth=0

RUN yarn add postcss postcss-cli autoprefixer

RUN npm install -g yarn@${YARN_VERSION} nodemon esbuild sass postcss postcss-cli autoprefixer
