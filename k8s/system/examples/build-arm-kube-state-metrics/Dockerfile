#
#kube state metrics arm (Pi4)- used in the prometheus helm chart
#
FROM golang:1.13-alpine AS builder
ARG VERSION

RUN apk add make git

WORKDIR /opt
RUN git clone https://github.com/kubernetes/kube-state-metrics.git . \
 && git fetch --tags \
 && git checkout $VERSION \
 && make build-local

# -----------------------------------------
FROM gcr.io/distroless/static

COPY --from=builder /opt/kube-state-metrics /
USER nobody
ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081

# TODO - run this as a build to create images in some automation
# # Create builkdit builder
# docker buildx create --name xbuilder
# docker buildx use xbuilder

# # Build. Adjust architectures to the ones needed
# VERSION=v1.9.1 (to match current helm chart)
# docker buildx build --build-arg VERSION=${VERSION} --platform linux/arm/v7,linux/amd64 --progress plain --push -t warpigg/kube-state-metrics:${VERSION} .
