FROM ubuntu:18.04 as uw-mailman-core
WORKDIR /app/

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
    postfix \
    postgresql

RUN locale-gen en_US.UTF-8
# locale.getdefaultlocale() searches in this order
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8

## if these don't really need to be in /etc/ then move them to /app
# these are copied into place via script/start.sh
ADD etc/ /app/etc
ADD requirements.txt /app/
ADD scripts /scripts

RUN groupadd -r mailman -g 1000 && \
    useradd -u 1000 -m -d /opt/mailman -s /bin/bash -g mailman mailman

RUN python3 -m venv /opt/mailman/venv

RUN chown -R mailman:mailman /app /opt/mailman requirements.txt && \
    chmod -R +x /scripts

RUN . /opt/mailman/venv/bin/activate && \
    pip install -U pip setuptools wheel && \
    pip install -r requirements.txt

ENV PORT 8000
ENV MAILMAN_CONFIG_FILE /opt/mailman/venv/etc/mailman.cfg

USER mailman

CMD ["/scripts/start.sh"]
