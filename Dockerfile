FROM alpine AS builder

ARG TAG
ARG SHA256SUM

RUN apk --no-cache add unzip \
    && mkdir -p /hath \
    && wget https://repo.e-hentai.org/hath/HentaiAtHome_${TAG}.zip -O hath.zip \
    && echo -n "${SHA256SUM}  hath.zip" | sha256sum -c \
    && unzip hath.zip -d /hath \
    && cd /hath \
    && mkdir -p /hath/data \
    && mkdir -p /hath/download

FROM azul/zulu-openjdk:18-jre AS release

COPY --from=builder /hath /hath
COPY scripts/run.sh /hath/run.sh
WORKDIR /hath

RUN apk --no-cache add sqlite \
    && chmod +x /hath/run.sh

VOLUME [ "/hath/data" , "/hath/download" ]

ENTRYPOINT ["/hath/run.sh"]