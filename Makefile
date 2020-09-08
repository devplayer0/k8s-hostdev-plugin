REPO ?= ghcr.io/devplayer0
TAG ?= latest
IMG=$(REPO)/k8s-hostdev-plugin:$(TAG)
BIN=k8s-hostdev-plugin

# GCFLAGS ?= -x -gcflags="-N -l"

all: bin


${BIN}: main.go server.go watcher.go
	CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' ${GCFLAGS} -o $@

bin: ${BIN}

clean:
	rm -f ${BIN}

# Run go fmt against code
fmt:
	go fmt ./...

# Run go vet against code
vet:
	go vet ./...

# Build the docker image
img: ${BIN} Dockerfile
	docker build -f Dockerfile  . -t ${IMG}

push:
	docker push ${IMG}

.PHONY : help clean all bin img push
