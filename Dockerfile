# Define the base image with Go installed
FROM golang:alpine AS builder
WORKDIR /app

# Copy your Go source code to the working directory
COPY . .

RUN go mod tidy
RUN go build -o main .

# Define the final image based on Alpine Linux
FROM alpine:latest
WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/etc/local.yaml ./etc/

EXPOSE 9090

CMD ["./main"]
