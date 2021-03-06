FROM alpine:latest

LABEL maintainer="miu.manu@gmx.de"

RUN apk --no-cache add --update coreutils bash curl jq git docker-cli gettext && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    # Temporary solution until the latest kustomize version is included in kubectl
    # https://kubernetes-sigs.github.io/kustomize/faq/#kubectl-doesnt-have-the-latest-kustomize-when-will-it-be-updated
    curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest |\
    grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | xargs curl -LO && \
    find . -iname 'kustomize*' | xargs tar xzf && \
    chmod +x ./kustomize && \
    mv ./kustomize /usr/local/bin/kustomize && \
    rm kustomize*

ENTRYPOINT /bin/bash
