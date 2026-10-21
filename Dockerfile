FROM alpine@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 as downloader

WORKDIR /workdir

COPY crowdin_script.sh ./crowdin

# renovate: datasource=github-releases depName=crowdin/crowdin-cli
ARG CROWDIN_VERSION=5.5.0

RUN apk add --no-cache wget unzip && \
    wget https://github.com/crowdin/crowdin-cli/releases/download/${CROWDIN_VERSION}/crowdin-cli.zip && \
    unzip crowdin-cli.zip && \
    chmod +x crowdin && \
    mv ${CROWDIN_VERSION}/crowdin-cli.jar .

FROM ibm-semeru-runtimes:open-17-jre-jammy@sha256:322c66222ee1dd5a7503c1df60d0387ba1c814a320de0b3fbe40199becbcaefc

WORKDIR /usr/crowdin-project

COPY --from=downloader /workdir/crowdin /usr/local/bin/crowdin
COPY --from=downloader /workdir/crowdin-cli.jar /usr/local/bin

ENTRYPOINT [ "crowdin" ]