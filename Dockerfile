FROM debian:bookworm AS builder
RUN apt-get update && apt-get install -y autoconf build-essential cmake pkg-config nasm wget

ARG LEANIFY_HASH=66d25e47613062117d8abbfef9e77fcab2abd57d
WORKDIR /opt/leanify
RUN wget -qO- github.com/JayXon/Leanify/archive/"$LEANIFY_HASH".tar.gz | tar zx --strip-components=1
RUN make -j$(nproc)

ARG ECT_HASH=28f0d8fc33bbfb15a6c10070b1ecbad992afb11e
WORKDIR /opt/ect
RUN wget -qO- github.com/fhanau/Efficient-Compression-Tool/archive/"$ECT_HASH".tar.gz | tar zx --strip-components=1
RUN wget -qO- github.com/glennrp/libpng/archive/a40189cf881e9f0db80511c382292a5604c3c3d1.tar.gz | tar zx --strip-components=1 -C src/libpng
RUN wget -qO- github.com/mozilla/mozjpeg/archive/06ee0dd3c2e6fb53c9a19f16a47d292f9e889d5c.tar.gz | tar zx --strip-components=1 -C src/mozjpeg
RUN cd src && cmake . && make -j$(nproc)

ARG GIFSICLE_HASH=bdac32963dca1b5b5134407a2034c900d576ae66
WORKDIR /opt/gifsicle
RUN wget -qO- github.com/kohler/gifsicle/archive/"$GIFSICLE_HASH".tar.gz | tar zx --strip-components=1
RUN autoreconf --install && ./configure && make -j$(nproc)

FROM debian:bookworm-slim
WORKDIR /data
RUN apt-get update && apt-get install -y bash ffmpeg imagemagick parallel libjemalloc2
ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so.2
COPY --from=builder /opt/leanify/leanify /usr/local/bin
COPY --from=builder /opt/ect/src/ect /usr/local/bin
COPY --from=builder /opt/gifsicle/src/gifsicle /usr/local/bin