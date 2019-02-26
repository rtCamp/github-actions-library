FROM debian:stable-slim

LABEL "name"="filter"
LABEL "maintainer"="GitHub Actions <support+actions@github.com>"
LABEL "version"="1.1.0"

LABEL "com.github.actions.name"="Branch filter for GitHub Actions"
LABEL "com.github.actions.description"="Branch filter to stop workflows"
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="gray-dark"

COPY LICENSE README.md THIRD_PARTY_NOTICE.md /

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
	jq \
	python \
	python-pip && \
	pip install --upgrade setuptools && \
	pip install shyaml && \
	apt-get clean -y && \
	rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/bin:${PATH}"

COPY bin /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x -R /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
