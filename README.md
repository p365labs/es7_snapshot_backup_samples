# Elasticsearch Snapshot backup samples

This repository contains some files to prove what
discussed into the tutorial you can find 
[https://medium.com/@federicopanini/elasticsearch7-backup-snapshot-restore-aws-s3-54a581c75589](https://medium.com/@federicopanini/elasticsearch7-backup-snapshot-restore-aws-s3-54a581c75589)

The idea is to setup an Elasticsearch cluster with Docker. A specific docker-compose file has been created to set it up a Cluster with 3 nodes.

Then you can play with the cluster and test what has been explained into the
Tutorial on Medium.

Simply there are three files:

- Dockerfile
- docker-compose.yml
- elasticsearch.yml

## Dockerfile

```yml
FROM docker.elastic.co/elasticsearch/elasticsearch:7.6.2

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch repository-s3

COPY --chown=elasticsearch:elasticsearch elasticsearch.yml /usr/share/elasticsearch/config/

RUN echo "YOUR_ACCESS_KEY" | bin/elasticsearch-keystore add --stdin --force s3.client.default.access_key
RUN echo "YOUR_SECRET_KEY" | bin/elasticsearch-keystore add --stdin --force s3.client.default.secret_key
```

It defines which Elasticsearch version you will use, it copy the elasticsearch.yml configuration file into the container, and before the cluster starts it will add, using the cli command elasticsearch-keystore, the AWS *access_key* and *secret_key*
in order to allow Elasticsearch backing it up the indices in an AWS S3 bucket.

## docker-compose.yml

```yml
version: '2.2'
services:
  es01:
    build: .
    container_name: es01
    environment:
      - node.name=es01
      - cluster.name=es-docker-cluster
      - discovery.seed_hosts=es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
      ....
      ....
      ....
```

It is the docker-compose file which create the Elasticsearch cluster. If you want more infos on it and how you can tweak Elasticsearch docker-compose file please
have a look at Elasticsearch docker [official documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.8/docker.html).
More than this Elastic is providing a full list of available [Docker images](https://www.docker.elastic.co/).


## elasticsearch.yml

This is the Elasticsearch base configuration file. In our example with are adding to it only one information which is the AWS region we are working with.

```yml
cluster.name: "docker-cluster"
network.host: 0.0.0.0

s3.client.default.endpoint: s3-eu-west-1.amazonaws.com
```