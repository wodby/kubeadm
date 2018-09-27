#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [[ -f kubeadm.tar.gz ]]; then
    gunzip kubeadm.tar.gz
    docker load --input kubeadm.tar
fi

exec dockerd-entrypoint.sh "${@}"
