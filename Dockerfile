FROM debian:buster-slim as builder
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y autoconf build-essential cmake pkg-config nasm wget

ARG LEANIFY_HASH=47a76d12a6c830467b68ad62c915d60692b44354
WORKDIR /root/leanify
RUN wget -qO- github.com/JayXon/Leanify/archive/"$LEANIFY_HASH".tar.gz | tar zx --strip-components=1
RUN make -j$(nproc)

ARG ECT_HASH=6da571546cafd649a08fa89c655a2532c71d7d7e
WORKDIR /root/ect
RUN wget -qO- github.com/fhanau/Efficient-Compression-Tool/archive/"$ECT_HASH".tar.gz | tar zx --strip-components=1
RUN wget -qO- github.com/glennrp/libpng/archive/v1.6.35.tar.gz | tar zx --strip-components=1 -C src/libpng
RUN cd src && make -j$(nproc)

WORKDIR /root/gifsicle
RUN wget -qO- github.com/kohler/gifsicle/archive/v1.92.tar.gz | tar zx --strip-components=1
RUN autoreconf --install && ./configure && make -j$(nproc)

FROM debian:buster-slim
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ffmpeg imagemagick parallel

COPY --from=builder /root/ect/ect /usr/local/bin
COPY --from=builder /root/leanify/leanify /usr/local/bin
COPY --from=builder /root/gifsicle/src/gifsicle /usr/local/bin
