IMAGE=josericardomcastro/kube-code-generator-tools:0.20.15
PROJECT_PACKAGE=github.com/josericardomcastro/kube-code-generator-tools/example

# Generate code api
generate-api:
	docker run -it --rm \
 		-v ${PWD}:/go/src/${PROJECT_PACKAGE} \
		-e PROJECT_PACKAGE=${PROJECT_PACKAGE} \
		-e CLIENT_GENERATOR_OUT=${PROJECT_PACKAGE}/pkg/generated \
		-e APIS_PKG=${PROJECT_PACKAGE}/pkg/apis \
		-e GROUPS_VERSION="samplecontroller:v1" \
		-e GENERATION_TARGETS="all" \
		${IMAGE}

# Generate crd
SOURCE_PROJECT=/go/src/${PROJECT_PACKAGE}
generate-crd:
	docker run -it --rm \
		-v ${PWD}:${SOURCE_PROJECT} \
		-e GO_PROJECT_ROOT=${SOURCE_PROJECT} \
		-e CRD_TYPES_PATH=${SOURCE_PROJECT}/pkg/apis \
		-e CRD_OUT_PATH=${SOURCE_PROJECT}/manifests \
		${IMAGE} ./generate-crd.sh