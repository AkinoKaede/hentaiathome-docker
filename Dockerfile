FROM alpine AS builder

ARG TAG
ARG SHA256SUM

RUN apk --no-cache add unzip \
    && mkdir -p /hath \
    && wget https://repo.e-hentai.org/hath/HentaiAtHome_${TAG}.zip -O hath.zip \
    && echo -n "${SHA256SUM}  hath.zip" | sha256sum -c \
    && unzip hath.zip -d /hath \
    && cd /hath \
    && mkdir -p /hath/data/data \
    && mkdir -p /hath/download

FROM eclipse-temurin:11 AS release

COPY --from=builder /hath /hath
COPY scripts/run.sh /hath/run.sh
WORKDIR /hath

RUN apt update \
    && apt install -y sqlite3 \
    && chmod +x /hath/run.sh

VOLUME [ "/hath/data" , "/hath/download" ]

ENTRYPOINT ["/hath/run.sh"]
