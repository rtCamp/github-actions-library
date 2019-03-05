FROM rtcamp/ci-deployer

LABEL "com.github.actions.name"="WordPress Plugin Deploy"
LABEL "com.github.actions.description"="Deploy to the WordPress Plugin Repository"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

RUN apt-get update \
	&& apt-get install -y subversion rsync \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
