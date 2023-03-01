FROM crowdin:cli

RUN apt-get update && \
    apt-get install -y curl git git-lfs jq gnupg && \
    curl -o entrypoint.sh https://raw.githubusercontent.com/crowdin/github-action/master/entrypoint.sh && \
    chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
