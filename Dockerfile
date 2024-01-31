FROM debian:bookworm-slim

COPY ./filesystem /.
COPY ./filesystem-shared-ca-certificates /.

RUN find /mnt -print

RUN set -x
RUN bash /mnt/pre-install.sh
RUN bash /mnt/setup-ca.sh
RUN bash /mnt/install.sh
RUN bash /mnt/supervisor.sh

EXPOSE 53

CMD ["/usr/bin/supervisord"]
