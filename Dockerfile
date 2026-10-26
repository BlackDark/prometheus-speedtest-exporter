FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

ENV SPEEDTEST_VERSION=1.2.0
ENV SCRIPT_EXPORTER_VERSION=v3.2.0
RUN apk add tar curl ca-certificates bash jq

RUN ARCH=$(apk info --print-arch) && \
    echo ARCH=$ARCH && \
    case "$ARCH" in \
      x86) _arch=i386 ;; \
      armv7) _arch=armhf ;; \
      *) _arch="$ARCH" ;; \
    esac && \
    echo https://install.speedtest.net/app/cli/ookla-speedtest-${SPEEDTEST_VERSION}-linux-${_arch}.tgz && \
    curl -fsSL -o /tmp/ookla-speedtest.tgz \
      https://install.speedtest.net/app/cli/ookla-speedtest-${SPEEDTEST_VERSION}-linux-${_arch}.tgz && \
    tar xvfz /tmp/ookla-speedtest.tgz -C /usr/local/bin speedtest && \
    rm -rf /tmp/ookla-speedtest.tgz

RUN ARCH=$(apk info --print-arch) && \
    case "$ARCH" in \
      x86_64) _arch=amd64 ;; \
      aarch64) _arch=arm64 ;; \
      *) _arch="$ARCH" ;; \
    esac && \
    echo https://github.com/ricoberger/script_exporter/releases/download/${SCRIPT_EXPORTER_VERSION}/script_exporter-linux-${_arch}.tar.gz && \
    curl -fsSL -o /tmp/script_exporter.tar.gz \
      https://github.com/ricoberger/script_exporter/releases/download/${SCRIPT_EXPORTER_VERSION}/script_exporter-linux-${_arch}.tar.gz && \
    tar xfz /tmp/script_exporter.tar.gz -C /usr/local/bin script_exporter && \
    chmod +x /usr/local/bin/script_exporter && \
    rm /tmp/script_exporter.tar.gz

COPY config.yaml config.yaml
COPY speedtest-exporter.sh /usr/local/bin/speedtest-exporter.sh

EXPOSE 9469

ENTRYPOINT  [ "/usr/local/bin/script_exporter", "--config.files=config.yaml" ]
