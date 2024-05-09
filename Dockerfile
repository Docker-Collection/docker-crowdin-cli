FROM alpine@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as downloader

WORKDIR /workdir

COPY crowdin_script.sh ./crowdin

# renovate: datasource=github-releases depName=crowdin/crowdin-cli
ARG CROWDIN_VERSION=3.19.3

RUN apk add --no-cache wget unzip && \
    wget https://github.com/crowdin/crowdin-cli/releases/download/${CROWDIN_VERSION}/crowdin-cli.zip && \
    unzip crowdin-cli.zip && \
    chmod +x crowdin && \
    mv ${CROWDIN_VERSION}/crowdin-cli.jar .

FROM ibm-semeru-runtimes:open-17-jre-jammy@sha256:14c4787d23a23889a2a3cd74399e598b1e1809ad3942b8c404e1c3467d24641c

WORKDIR /usr/crowdin-project

COPY --from=downloader /workdir/crowdin /usr/local/bin/crowdin
COPY --from=downloader /workdir/crowdin-cli.jar /usr/local/bin

ENTRYPOINT [ "crowdin" ]