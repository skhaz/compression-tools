FROM debian:bookworm AS builder
RUN apt-get update
RUN apt-get install -y autoconf build-essential cmake pkg-config nasm wget

ARG LEANIFY_HASH=5ffce235997dc64054e634b2511ad1c6cc07794b
WORKDIR /opt/leanify
RUN wget -qO- github.com/JayXon/Leanify/archive/"$LEANIFY_HASH".tar.gz | tar zx --strip-components=1
RUN make -j$(nproc)

ARG ECT_HASH=53d5a0c13e42a1668990b8537ed4c48234886c91
WORKDIR /opt/ect
RUN wget -qO- github.com/fhanau/Efficient-Compression-Tool/archive/"$ECT_HASH".tar.gz | tar zx --strip-components=1
RUN wget -qO- github.com/glennrp/libpng/archive/07b8803110da160b158ebfef872627da6c85cbdf.tar.gz | tar zx --strip-components=1 -C src/libpng
RUN wget -qO- github.com/mozilla/mozjpeg/archive/cf6facaedb8f8ded44e6c41b0db8a721d329ff22.tar.gz | tar zx --strip-components=1 -C src/mozjpeg
RUN cd src && cmake . && make -j$(nproc)

ARG GIFSICLE_HASH=bdac32963dca1b5b5134407a2034c900d576ae66
WORKDIR /opt/gifsicle
RUN wget -qO- github.com/kohler/gifsicle/archive/"$GIFSICLE_HASH".tar.gz | tar zx --strip-components=1
RUN autoreconf --install && ./configure && make -j$(nproc)

FROM debian:bookworm-slim
WORKDIR /data
RUN apt-get update
RUN apt-get install -y bash ffmpeg imagemagick parallel

COPY --from=builder /opt/leanify/leanify /usr/local/bin
COPY --from=builder /opt/ect/src/ect /usr/local/bin
COPY --from=builder /opt/gifsicle/src/gifsicle /usr/local/bin