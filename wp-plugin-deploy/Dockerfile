# rtcamp/wp-plugin-base:latest at 2019-03-18T15:20:50IST
FROM rtcamp/wp-plugin-base@sha256:4a9c373e6a03d756390693a4a32c6976aff54d65b8b1c65d14e7a4eca9227c60

LABEL "com.github.actions.name"="WordPress Plugin Deploy"
LABEL "com.github.actions.description"="Deploy to the WordPress Plugin Repository"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /*.sh
ENTRYPOINT ["/entrypoint.sh"]
