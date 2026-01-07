# Lightweight Debian-based image for running p0ckit
FROM debian:bookworm-slim

LABEL maintainer="p0ckit <noreply@example.com>"

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        git \
        python3 \
        nmap \
        npm \
        curl \
        jq \
        sudo \
        lsof \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create app directory and copy sources
WORKDIR /opt/p0ckit
COPY . /opt/p0ckit

#this like is just coz windows wants to be a stupid bitch
RUN find /opt/p0ckit -type f -exec sed -i 's/\r//g' {} +

# Ensure entry script is executable
RUN chmod +x /opt/p0ckit/p0ckit.sh

# Expose nothing by default; keep container interactive for CLI use
ENTRYPOINT ["bash", "/opt/p0ckit/p0ckit.sh"]
CMD [""]
