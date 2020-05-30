FROM docker.elastic.co/elasticsearch/elasticsearch:7.6.2

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch repository-s3

COPY --chown=elasticsearch:elasticsearch elasticsearch.yml /usr/share/elasticsearch/config/

RUN echo "YOUR_ACCESS_KEY" | bin/elasticsearch-keystore add --stdin --force s3.client.default.access_key
RUN echo "YOUR_SECRET_KEY" | bin/elasticsearch-keystore add --stdin --force s3.client.default.secret_key


