# build stage
FROM golang:1.22 AS builder
WORKDIR /app

ENV GOPROXY=https://proxy.golang.org,direct

COPY . .

# кешируем модули (BuildKit)
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app .

# runtime stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/app ./app
CMD ["./app"]
