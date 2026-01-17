# build stage (debian based - more stable for TLS/proxy)
FROM golang:1.22 AS builder
WORKDIR /app

ENV GOPROXY=https://proxy.golang.org,direct
ENV GONOSUMDB=
ENV GOPRIVATE=

COPY go.mod go.sum ./
RUN go mod download -x

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app .

# runtime stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/app ./app
CMD ["./app"]
