FROM arm32v7/alpine

WORKDIR /usr/local/bin
RUN apk --no-cache add ca-certificates

RUN addgroup -S polaris && adduser -u 1200 -S polaris -G polaris
USER 1200
COPY polaris .

WORKDIR /opt/app

CMD ["polaris"]
