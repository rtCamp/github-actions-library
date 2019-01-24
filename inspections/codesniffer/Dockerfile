# alpine:latest at 2019-01-04T21:27:39IST
FROM alpine@sha256:46e71df1e5191ab8b8034c5189e325258ec44ea739bba1e5645cff83c9048ff1

LABEL "com.github.actions.name"="PHPCodeSniffer"
LABEL "com.github.actions.description"="Check phpcs rules in the diff getting deployed"

RUN apk update \
	&& apk upgrade \
	&& apk add \
		bash \
		jq \
		curl \
		git \
    && rm -rf /var/cache/apk/*

COPY phpcs.sh /
RUN chmod +x /phpcs.sh

ENTRYPOINT ["/phpcs.sh"]
