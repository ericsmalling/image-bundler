FROM cgr.dev/chainguard/wolfi-base as image-configs
RUN apk update && apk add jq crane gosu
COPY make-dynamic-entrypoint.sh /make-dynamic-entrypoint.sh

RUN crane config docker.io/stargateio/stargate-4_0:v1.0.77 | jq .config > /stargate.json
RUN /bin/sh -c "/make-dynamic-entrypoint.sh /stargate.json > /stargate-entrypoint.sh"
RUN chmod +x /stargate-entrypoint.sh

RUN crane config cr.k8ssandra.io/k8ssandra/k8ssandra-operator:v1.12.0 | jq .config > /k8ssandra-operator.json
RUN /bin/sh -c "/make-dynamic-entrypoint.sh /k8ssandra-operator.json > /k8ssandra-operator-entrypoint.sh"
RUN chmod +x /k8ssandra-operator-entrypoint.sh

FROM docker.io/stargateio/stargate-4_0:v1.0.77 as stargate
COPY --from=image-configs /stargate-entrypoint.sh /dynamic-entrypoint.sh

FROM cr.k8ssandra.io/k8ssandra/k8ssandra-operator:v1.12.0 as k8ssandra-operator
COPY --from=image-configs /k8ssandra-operator-entrypoint.sh /dynamic-entrypoint.sh

FROM cgr.dev/chainguard/wolfi-base
RUN apk add jq
COPY --from=cr.dtsx.io/datastax/cass-config-builder:1.0-ubi8 / /cass-config-builder
COPY --from=cr.k8ssandra.io/k8ssandra/cass-management-api:4.0.1 / /cass-management-api
COPY --from=cr.k8ssandra.io/k8ssandra/cass-operator:v1.18.2 / /cass-operator
COPY --from=k8ssandra-operator / /k8ssandra-operator
COPY --from=cr.k8ssandra.io/k8ssandra/system-logger:v1.18.2 / /system-logger
COPY --from=stargate / /stargate

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]