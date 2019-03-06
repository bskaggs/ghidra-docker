ARG BASE_IMAGE=openjdk:11-slim
FROM ${BASE_IMAGE}

ARG GHIDRA_VERSION=9.0_PUBLIC_20190228
WORKDIR /opt
RUN apt-get update && apt-get install -y wget gettext-base && \
    wget -q -O ghidra.zip https://ghidra-sre.org/ghidra_${GHIDRA_VERSION}.zip && \
    unzip ghidra.zip && \
    rm ghidra.zip && \ 
    ln -s ghidra* ghidra && \
    useradd --system --shell /bin/false ghidra && \
    mkdir -p /srv/repositories && \
    chown -R ghidra: ghidra* /srv/repositories
USER ghidra
VOLUME /srv/repositories
WORKDIR /opt/ghidra
ENV ghidra_home=/opt/ghidra
COPY --chown=ghidra:ghidra server.sh /opt/ghidra
EXPOSE 13100
EXPOSE 13101
EXPOSE 13102
CMD ["/opt/ghidra/server.sh"]
