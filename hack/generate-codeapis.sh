#!/usr/bin/env bash

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

set -o errexit
set -o nounset
set -o pipefail

PROJECT_PACKAGE="${PROJECT_PACKAGE:-""}"
CLIENT_GENERATOR_OUT="${CLIENT_GENERATOR_OUT:-""}"
APIS_PKG="${APIS_PKG:-""}"
GROUPS_VERSION="${GROUPS_VERSION:-""}"

[ -z "$PROJECT_PACKAGE" ] && echo "PROJECT_PACKAGE env var is required" && exit 1
[ -z "$CLIENT_GENERATOR_OUT" ] && echo "CLIENT_GENERATOR_OUT env var is required" && exit 1
[ -z "$APIS_PKG" ] && echo "APIS_PKG env var is required" && exit 1
[ -z "$GROUPS_VERSION" ] && echo "GROUPS_VERSION env var is required" && exit 1

# Check:
# - https://github.com/kubernetes/community/blob/master/contributors/devel/sig-api-machinery/generating-clientset.md
GENERATION_TARGETS="${GENERATION_TARGETS:-all}"

# From >=1.16 we use gomod, so we need to execute from the project directory.
cd "${GOPATH}/src/${PROJECT_PACKAGE}"

# Ugly but needs to be relative if we want to use k8s.io/code-generator
# as it is without touching/sed-ing the code/scripts
RELATIVE_ROOT_PATH=$(realpath --relative-to="${PWD}" /)
CODEGEN_PKG=${RELATIVE_ROOT_PATH}${GOPATH}/src/k8s.io/code-generator

#Usage: $(basename "$0") <generators> <output-package> <apis-package> <groups-versions> ...
#  <generators>        the generators comma separated to run (deepcopy,defaulter,client,lister,informer) or "all".
#  <output-package>    the output package name (e.g. github.com/example/project/pkg/generated).
#  <apis-package>      the external types dir (e.g. github.com/example/api or github.com/example/project/pkg/apis).
#  <groups-versions>   the groups and their versions in the format "groupA:v1,v2 groupB:v1 groupC:v2", relative
#                      to <api-package>.
#  ...                 arbitrary flags passed to all generator binaries.
#Examples:
#  $(basename "$0") all             github.com/example/project/pkg/client github.com/example/project/pkg/apis "foo:v1 bar:v1alpha1,v1beta1"
#  $(basename "$0") deepcopy,client github.com/example/project/pkg/client github.com/example/project/pkg/apis "foo:v1 bar:v1alpha1,v1beta1"

${CODEGEN_PKG}/generate-groups.sh \
            ${GENERATION_TARGETS} \
            ${CLIENT_GENERATOR_OUT} \
            ${APIS_PKG} \
            "${GROUPS_VERSION}" \
            "--go-header-file=/usr/bin/boilerplate.go.txt"