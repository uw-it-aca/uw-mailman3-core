FROM ubuntu:20.04 as uw-mailman-core
WORKDIR /app/
ENV PYTHONUNBUFFERED 1
ENV TZ America/Los_Angeles
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get clean all && \
    apt-get install -y \
    locales \
    gcc \
    python-setuptools \
    python3-dev \
    python3-venv \
    sassc \
    lynx \
    libpq-dev \
    curl \
    cron \
    postgresql

RUN locale-gen en_US.UTF-8
# locale.getdefaultlocale() searches in this order
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8


# create mailman directory, prep virtualenv
RUN python3 -m venv /app/mailman

## /config holds configmap'd config files and templates
RUN mkdir /config
ADD requirements.txt /app/
ADD scripts /scripts

RUN groupadd -r mailman -g 1000 && \
    useradd -u 1000 -m -d /app/mailman/var -s /bin/bash -g mailman mailman

RUN chown -R mailman:mailman /app /app/mailman requirements.txt && \
    chmod -R +x /scripts

RUN . /app/mailman/bin/activate && \
    pip install -U pip setuptools wheel && \
    pip install -r requirements.txt

ENV PORT 8000
ENV MAILMAN_CONFIG_FILE /app/mailman/var/etc/mailman.cfg
ENV MAILMAN_VAR_DIR /app/mailman/var

ADD certs certs
RUN cat certs/uwca.crt >> /etc/ssl/certs/ca-certificates.crt

USER mailman

CMD ["/scripts/start.sh"]
