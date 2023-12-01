FROM alpine@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0 as downloader

WORKDIR /workdir

COPY crowdin_script.sh ./crowdin

# renovate: datasource=github-releases depName=crowdin/crowdin-cli
ARG CROWDIN_VERSION=3.15.0

RUN apk add --no-cache wget unzip && \
    wget https://github.com/crowdin/crowdin-cli/releases/download/${CROWDIN_VERSION}/crowdin-cli.zip && \
    unzip crowdin-cli.zip && \
    chmod +x crowdin && \
    mv ${CROWDIN_VERSION}/crowdin-cli.jar .

FROM ibm-semeru-runtimes:open-17-jre-jammy@sha256:c390d297fe336c41b1afb1faec0f50b1cfdee0933bd2ac6ff106567f7446b018

WORKDIR /usr/crowdin-project

COPY --from=downloader /workdir/crowdin /usr/local/bin/crowdin
COPY --from=downloader /workdir/crowdin-cli.jar /usr/local/bin

ENTRYPOINT [ "crowdin" ]