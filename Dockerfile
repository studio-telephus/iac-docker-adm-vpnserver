FROM debian:bookworm

COPY ./filesystem /.
COPY ./filesystem-shared-ca-certificates /.

RUN find /mnt -print

RUN export DEBIAN_FRONTEND=noninteractive

RUN set -x
RUN bash /mnt/pre-install.sh
RUN bash /mnt/setup-ca.sh
RUN bash /mnt/install.sh
RUN bash /mnt/supervisor.sh

EXPOSE 11150 11150/udp

CMD ["/usr/bin/supervisord"]
