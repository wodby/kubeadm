#!/usr/bin/env bash

set -ex

image="${1}"
version="${2}"

cid="$(docker run -d --privileged "${image}")"

docker exec "${cid}" docker pull "mirantis/kubeadm-dind-cluster:v${version}"
docker exec "${cid}" sh -c "docker save mirantis/kubeadm-dind-cluster:v${version} > kubeadm.tar"
docker exec "${cid}" gzip kubeadm.tar
docker commit "${cid}" "${image}"

trap "docker rm -vf ${cid} > /dev/null" EXIT

