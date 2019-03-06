FROM daocloud.io/alpine:3.8

ENV ETCD_VERSION 3.2.25
ENV KUBE_VERSION 1.10.11

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update && apk add --update bash curl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

RUN curl -L http://dao-get.daocloud.io/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl > /usr/local/bin/kubectl

RUN cd /tmp \
    && curl -OL https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz \
    && tar zxf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz \
    && cp etcd-v${ETCD_VERSION}-linux-amd64/etcdctl /usr/local/bin/etcdctl \
    && rm -rf etcd-v${ETCD_VERSION}-linux-amd64* \
    && chmod +x /usr/local/bin/etcdctl

COPY docker-clean.sh k8s-clean.sh etcd-empty-dir-cleanup.sh /bin/
RUN chmod +x /bin/docker-clean.sh /bin/k8s-clean.sh /bin/etcd-empty-dir-cleanup.sh

ENV DOCKER_CLEAN_INTERVAL 86400
ENV K8S_CLEAN_DAYS 7

CMD ["bash", "/bin/docker-clean.sh"]
