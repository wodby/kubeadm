FROM docker:18.06.1-ce-dind

ARG KUBEADM_VER

ENV KUBEADM_VER="${KUBEADM_VER}" \
    NUM_NODES=0 \
    DASHBOARD_URL="" \
    SKIP_SNAPSHOT="1" \
    KUBECTL_DIR="/usr/local/bin"

RUN set -ex; \
    \
    apk add --no-cache --update curl bash jq; \
    \
    url="https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/master/fixed/dind-cluster-v${KUBEADM_VER}.sh"; \
    wget "${url}" -O /usr/local/bin/kubeadm; \
    chmod +x /usr/local/bin/kubeadm; \
    { \
        echo; \
        echo 'if [[ -f /images/kubeadm.tar.gz ]]; then'; \
        echo '  gunzip /images/kubeadm.tar.gz'; \
        echo '  docker load --input /images/kubeadm.tar'; \
        echo 'fi'; \
        echo; \
    } | tee load-images.sh; \
    sed -i '/#!/r load-images.sh' /usr/local/bin/kubeadm; \
    rm load-images.sh; \
    \
    wget -q https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh; \
    sed -i 's/$(go env GOARCH)/amd64/' download-frozen-image-v2.sh; \
    sed -i 's/$(go env GOHOSTOS)/linux/' download-frozen-image-v2.sh; \
    mkdir -p /images/kubeadm; \
    bash download-frozen-image-v2.sh /images/kubeadm "mirantis/kubeadm-dind-cluster:v${KUBEADM_VER}"; \
    tar cvzf /images/kubeadm.tar.gz -C /images/kubeadm .; \
    \
    rm -rf \
        download-frozen-image-v2.sh \
        /images/kubeadm \
        /var/cache/apk/*
