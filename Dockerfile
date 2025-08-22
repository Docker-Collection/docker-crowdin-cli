FROM alpine@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 as downloader

WORKDIR /workdir

COPY crowdin_script.sh ./crowdin

# renovate: datasource=github-releases depName=crowdin/crowdin-cli
ARG CROWDIN_VERSION=4.10.0

RUN apk add --no-cache wget unzip && \
    wget https://github.com/crowdin/crowdin-cli/releases/download/${CROWDIN_VERSION}/crowdin-cli.zip && \
    unzip crowdin-cli.zip && \
    chmod +x crowdin && \
    mv ${CROWDIN_VERSION}/crowdin-cli.jar .

FROM ibm-semeru-runtimes:open-17-jre-jammy@sha256:20f56102314e2ca6e8078f8ccf778bcd62cf21341809c07b3346cc8520385208

WORKDIR /usr/crowdin-project

COPY --from=downloader /workdir/crowdin /usr/local/bin/crowdin
COPY --from=downloader /workdir/crowdin-cli.jar /usr/local/bin

ENTRYPOINT [ "crowdin" ]