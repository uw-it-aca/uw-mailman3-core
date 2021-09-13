FROM ubuntu:18.04 as uw-mailman-core
WORKDIR /app/

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get clean all && \
    apt-get install -y \
    locales \
    gcc \
    python-setuptools \
    python3.6-dev \
    python3-venv \
    libpq-dev \
    curl \
    postfix \
    postgresql

RUN locale-gen en_US.UTF-8
# locale.getdefaultlocale() searches in this order
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8

RUN python3 -m venv /app/
RUN groupadd -r acait -g 1000 && \
    useradd -u 1000 -rm -g acait -d /home/acait -s /bin/bash -c "container user" acait && \
    chown -R acait:acait /app && \
    chown -R acait:acait /home/acait

ADD scripts /scripts

## if these don't really need to be in /etc/ then move them to /app
# these are copied into place via script/start.sh
#COPY etc/mailman.cfg /etc/
#COPY etc/mailman-hyperkitty.cfg /etc/
#COPY etc/postfix-mailman.cfg /etc
#COPY etc/gunicorn.cfg /etc

USER acait
RUN mkdir -p database && chown acait:acait database
RUN python3 -m pip install -U pip setuptools wheel \
    && python3 -m pip install psycopg2 \
            gunicorn==19.9.0 \
            mailman==3.3.4 \
            mailman-hyperkitty==1.1.0

ENV MAILMAN_CONFIG_FILE /etc/mailman.cfg

USER root

CMD ["scripts/start.sh"]
