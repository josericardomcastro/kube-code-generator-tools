# kube-code-generator-tools

Kubernetes code generator code for custom resources apis (client, lister and informer) e crd manifests.

## Purpose

These code-generator tools can be used
- in the context of CustomResourceDefinition to build native, versioned clients, informers and other helpers
- in the context of User-provider API Servers to build conversions between internal and versioned types, defaulters, protobuf codecs, internal and versioned clients and informers.
- to generate CRD manifest YAMLs to register your Custom Resources on the k8s cluster.

This project makes use of the generators in [k8s.io/code-generator](https://github.com/kubernetes/code-generator) and sigs to generate a typed client, informers, listers and deep-copy functions.

And will create theses files for the api:

- pkg/apis/samplecontroller/v1/zz_generated.deepcopy.go
- pkg/generated/

## Compatibility versions

|                   | Docker image                                         |
|-------------------|------------------------------------------------------|
| Kubernetes v1.22  | `josericardomcastro/kube-code-generator-tools:0.22.1` |
| Kubernetes v1.20  | `josericardomcastro/kube-code-generator-tools:0.20.15` |

## How to use

Check it out the project [example](example) that generate code apis and CRD manifests for the Foo api resource.

### Generate code API

```
PROJECT_PACKAGE=github.com/example/project
docker run -it --rm \
    -v ${PWD}:/go/src/${PROJECT_PACKAGE} \
    -e PROJECT_PACKAGE=${PROJECT_PACKAGE} \
    -e CLIENT_GENERATOR_OUT=${PROJECT_PACKAGE}/pkg/generated \
    -e APIS_PKG=${PROJECT_PACKAGE}/pkg/apis \
    -e GROUPS_VERSION="sample:v1" \
    -e GENERATION_TARGETS="all" \
    josericardomcastro/kube-code-generator-tools:0.22.1
```

### Generate CRD manifest

```
SOURCE_PROJECT=/go/src/github.com/example/project
docker run -it --rm \
    -v ${PWD}:${SOURCE_PROJECT} \
    -e GO_PROJECT_ROOT=${SOURCE_PROJECT} \
    -e CRD_TYPES_PATH=${SOURCE_PROJECT}/pkg/apis \
    -e CRD_OUT_PATH=${SOURCE_PROJECT}/manifests \
    josericardomcastro/kube-code-generator-tools:0.22.1 ./generate-crd.sh
```

### Credits

This project is based on the other projects.

- [kubernetes/sample-controller](https://github.com/kubernetes/sample-controller)
- [kubernetes/code-generator](https://github.com/kubernetes/code-generator)
- [kubernetes-sigs/controller-tools](https://github.com/kubernetes-sigs/controller-tools)
- [slok/kube-code-generator](https://github.com/slok/kube-code-generator)
