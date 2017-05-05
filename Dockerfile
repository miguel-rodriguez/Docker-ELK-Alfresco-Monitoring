FROM sebp/elk:530

# Increase vm
RUN cat "vm.max_map_count=262144" >> /etc/sysctl.conf
RUN sysctl -p

# Install custom logstash configuration
ADD logstash.conf /etc/logstash/conf.d/logstash.conf

# Install and run redis
RUN apt-get install -y redis-server
RUN sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf

# Install activities files
RUN mkdir /opt/activities
RUN mkdir -p /data/logs/activities
ADD SQLTool.jar /opt/activities
ADD activities.properties /opt/activities

# Install activities files
RUN mkdir /opt/workflows
RUN mkdir -p /data/logs/workflows
ADD SQLTool.jar /opt/workflows
ADD workflows.properties /opt/workflows

RUN chown -R logstash /opt/activities
RUN chown -R logstash /opt/workflows
RUN chown -R logstash /data

# Add starting script
ADD startELK.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startELK.sh

RUN sed -i 's/network.host/#network.host/' /etc/elasticsearch/elasticsearch.yml
RUN echo "path.data: /var/lib/alf-elasticsearch" >> /etc/elasticsearch/elasticsearch.yml

ADD nodes.tar.gz /tmp
RUN /etc/init.d/elasticsearch stop
RUN mkdir -p /var/lib/alf-elasticsearch/
RUN chown -R elasticsearch /var/lib/alf-elasticsearch
RUN sed -i 's/DATA_DIR=\/var\/lib\/\$NAME/DATA_DIR=\/var\/lib\/alf-elasticsearch/' /etc/init.d/elasticsearch
RUN /etc/init.d/elasticsearch start
RUN /etc/init.d/elasticsearch stop
RUN rm -rf /var/lib/alf-elasticsearch/*
RUN cp -pr /tmp/nodes /var/lib/alf-elasticsearch
RUN chown -R elasticsearch /var/lib/alf-elasticsearch
RUN /etc/init.d/elasticsearch start
RUN /etc/init.d/elasticsearch stop

RUN mv /usr/local/bin/start.sh /tmp

ENTRYPOINT chmod +x /usr/local/bin/startELK.sh && /usr/local/bin/startELK.sh
