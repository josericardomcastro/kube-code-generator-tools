# Copyright 2022
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.16

ARG K8S_VERSION="v0.20.15"
ARG CONTROLLER_TOOL_VERSION="0.7.0"

RUN apt-get update && apt-get install -y git

## Packages and tools for code generator

## Golang code-generators used to implement Kubernetes-style API types.
## https://github.com/kubernetes/code-generator
RUN wget https://github.com/kubernetes/code-generator/archive/refs/tags/${K8S_VERSION}.tar.gz && \
    mkdir -p /go/src/k8s.io/code-generator/ && \
    tar zxvf ${K8S_VERSION}.tar.gz --strip 1 -C /go/src/k8s.io/code-generator/ && \
    rm ${K8S_VERSION}.tar.gz

## Scheme, typing, encoding, decoding, and conversion packages for Kubernetes and Kubernetes-like API objects.
## https://github.com/kubernetes/apimachinery   
RUN wget https://github.com/kubernetes/apimachinery/archive/refs/tags/${K8S_VERSION}.tar.gz && \
    mkdir -p /go/src/k8s.io/apimachinery/ && \
    tar zxvf ${K8S_VERSION}.tar.gz --strip 1 -C /go/src/k8s.io/apimachinery/ && \
    rm ${K8S_VERSION}.tar.gz

## Schema of the external API types that are served by the Kubernetes API server.
## https://github.com/kubernetes/api   
RUN wget https://github.com/kubernetes/api/archive/refs/tags/${K8S_VERSION}.tar.gz && \
    mkdir -p /go/src/k8s.io/api/ && \
    tar zxvf ${K8S_VERSION}.tar.gz --strip 1 -C /go/src/k8s.io/api/ && \
    rm ${K8S_VERSION}.tar.gz
    
## The Kubernetes controller-tools Project is a set of go libraries for building Controllers.
## https://github.com/kubernetes-sigs/controller-tools    
RUN wget https://github.com/kubernetes-sigs/controller-tools/archive/v${CONTROLLER_TOOL_VERSION}.tar.gz && \
    tar xvf ./v${CONTROLLER_TOOL_VERSION}.tar.gz && \
    cd ./controller-tools-${CONTROLLER_TOOL_VERSION}/ && \
    go build -o controller-gen  ./cmd/controller-gen/ && \
    mv ./controller-gen /usr/bin/ && \
    rm -rf ../v${CONTROLLER_TOOL_VERSION}.tar.gz && \
    rm -rf ../controller-tools-${CONTROLLER_TOOL_VERSION}


## Create the user 
ARG uid=1000
ARG gid=1000
RUN addgroup --gid $gid codegen && \
    adduser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password --uid $uid --ingroup codegen codegen && \
    chown codegen:codegen -R /go

## Copy the scripts path
COPY hack /hack
RUN chown codegen:codegen -R /hack && \
    mv /hack/* /usr/bin

ENV GOROOT="/usr/local/go"

USER codegen

WORKDIR /usr/bin

CMD ["generate-codeapis.sh"]