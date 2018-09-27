FROM docker:18.06.1-ce-dind

ARG KUBEADM_VER

ENV KUBEADM_VER="${KUBEADM_VER}" \
    NUM_NODES=0 \
    DASHBOARD_URL="" \
    SKIP_SNAPSHOT="1" \
    KUBECTL_DIR="/usr/local/bin"

RUN set -ex; \
    apk add --no-cache --update curl bash; \
    url="https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/master/fixed/dind-cluster-v${KUBEADM_VER}.sh"; \
    wget "${url}" -O /usr/local/bin/kubeadm; \
    chmod +x /usr/local/bin/kubeadm; \
    mkdir -p /docker

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD []
