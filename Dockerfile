FROM kfp-components-docker-dev-local.artifactory.dhl.com/alpine:latest

RUN apk add --no-cache bash pcre grep curl git

COPY action.yaml action.yaml
COPY entrypoint.sh entrypoint.sh
COPY script.sh script.sh

RUN chmod u+x /entrypoint.sh
RUN chmod u+x /script.sh

ENTRYPOINT ["/entrypoint.sh"]
