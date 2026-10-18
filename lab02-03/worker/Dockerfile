FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y curl jq cron && \
    rm -rf /var/lib/apt/lists/*

COPY pokemon.sh /usr/local/bin/pokemon.sh
RUN chmod +x /usr/local/bin/pokemon.sh

COPY cron /etc/cron.d/task
RUN chmod 0644 /etc/cron.d/task

CMD ["/bin/bash", "-c", "/usr/local/bin/pokemon.sh pikachu && cron -f"]
