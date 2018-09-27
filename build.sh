#!/usr/bin/env bash

set -ex

image="${1}"
version="${2}"

cid="$(make start)"

docker exec "${cid}" docker pull "mirantis/kubeadm-dind-cluster:v${version}"
docker exec "${cid}" sh -c "docker save mirantis/kubeadm-dind-cluster:v${version} > kubeadm.tar"
docker exec "${cid}" gzip kubeadm.tar
docker commit "${cid}" "${image}"

make clean
