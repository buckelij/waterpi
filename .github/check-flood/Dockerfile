FROM alpine
RUN apk update && apk add bash curl jq
COPY . /
ENTRYPOINT ["/check-flood.sh"]
