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

GO_PROJECT_ROOT="${GO_PROJECT_ROOT:-""}"
CRD_TYPES_PATH="${CRD_TYPES_PATH:-""}"
CRD_OUT_PATH="${CRD_OUT_PATH:-""}"
CRD_FLAG="${CRD_FLAG:-"crd:crdVersions=v1"}"

[ -z "$GO_PROJECT_ROOT" ] && echo "GO_PROJECT_ROOT env var is required" && exit 1
[ -z "$CRD_TYPES_PATH" ] && echo "CRD_TYPES_PATH env var is required" && exit 1
[ -z "$CRD_OUT_PATH" ] && echo "CRD_OUT_PATH env var is required" && exit 1

GO_PROJECT_ROOT=$(realpath ${GO_PROJECT_ROOT})
CRD_TYPES_PATH=$(realpath ${CRD_TYPES_PATH})
CRD_OUT_PATH=$(realpath ${CRD_OUT_PATH})

cd ${GO_PROJECT_ROOT}

# Needs relative paths.
CRD_TYPES_PATH=$(realpath --relative-to="${PWD}" ${CRD_TYPES_PATH})
CRD_OUT_PATH=$(realpath --relative-to="${PWD}" ${CRD_OUT_PATH})

mkdir -p ${CRD_OUT_PATH}
echo "Generating CRD manifests..."

## Generate RBAC manifests and crds for all types under apis/
## docs: https://github.com/kubernetes-sigs/controller-tools/blob/master/cmd/controller-gen/main.go
## controller-gen rbac:roleName=<role name> crd paths=./apis/... output:crd:dir=/tmp/crds output:stdout
controller-gen "${CRD_FLAG}" paths="./${CRD_TYPES_PATH}/..." output:dir="./${CRD_OUT_PATH}"
