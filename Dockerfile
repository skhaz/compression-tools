FROM debian:buster AS builder
RUN apt-get update && apt-get install -y autoconf build-essential cmake pkg-config nasm wget

ARG LEANIFY_HASH=b5f2efccde6f57c4dfecc2006e75444621763fd4
WORKDIR /root/leanify
RUN wget -qO- github.com/JayXon/Leanify/archive/"$LEANIFY_HASH".tar.gz | tar zx --strip-components=1
RUN make -j$(nproc)

ARG ECT_HASH=777dcb8548640eba9d4b7c8337b01caefecdf5cf
WORKDIR /root/ect
RUN wget -qO- github.com/fhanau/Efficient-Compression-Tool/archive/"$ECT_HASH".tar.gz | tar zx --strip-components=1
RUN wget -qO- github.com/glennrp/libpng/archive/v1.6.35.tar.gz | tar zx --strip-components=1 -C src/libpng
RUN cd src && make -j$(nproc)

ARG GIFSICLE_HASH=e13d08de9ced1c1ab9371454e3e97f47be2674e5
WORKDIR /root/gifsicle
RUN wget -qO- github.com/kohler/gifsicle/archive/"$GIFSICLE_HASH".tar.gz | tar zx --strip-components=1
RUN autoreconf --install && ./configure && make -j$(nproc)

FROM debian:buster-slim
RUN apt-get update && apt-get install -y ffmpeg imagemagick parallel libjemalloc2

ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so.2
COPY --from=builder /root/ect/ect /usr/local/bin
COPY --from=builder /root/leanify/leanify /usr/local/bin
COPY --from=builder /root/gifsicle/src/gifsicle /usr/local/bin

WORKDIR /data