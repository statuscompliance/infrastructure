FROM nodered/node-red:4.0.9-22-minimal

## As /data is usually going to be used to provide the node-red flows, we change the cache
## to another directory, since when mounting /data the cache will be lost
USER root

RUN mkdir -p /npm_cache && \
  chown node-red:node-red /npm_cache && \
  npm config set cache /npm_cache --global

USER node-red

RUN npm install --save @statuscompliance/status @statuscompliance/control-flow @statuscompliance/extraction  @statuscompliance/filtering @statuscompliance/integration @statuscompliance/logic @statuscompliance/validation

EXPOSE 1880


ENTRYPOINT ["node-red"]