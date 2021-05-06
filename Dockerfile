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
    postfix

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

USER acait
RUN /app/bin/pip install -U setuptools
RUN /app/bin/pip install mailman

CMD /bin/bash
