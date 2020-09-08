FROM golang:1.15-alpine AS builder
RUN apk --no-cache add gcc musl-dev

WORKDIR /go/src/k8s-hostdev-plugin
COPY go.* ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o /go/bin/k8s-hostdev-plugin


FROM alpine:3.12

COPY --from=builder /go/bin/k8s-hostdev-plugin /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/k8s-hostdev-plugin"]
