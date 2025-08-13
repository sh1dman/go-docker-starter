# Multi-stage build Dockerfile for Go application

# Stage 1: Build stage
FROM golang:1.21-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files first (for better caching)
COPY go.mod ./
COPY go.sum* ./

# Download dependencies (this layer will be cached if go.mod doesn't change)
RUN go mod download

# Copy the source code
COPY . .

# Build the application
# CGO_ENABLED=0: Disable CGO for a static binary
# GOOS=linux: Target Linux OS
# -a: Force rebuilding of packages
# -installsuffix cgo: Add suffix to package installation directory
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main cmd/server/main.go

# Stage 2: Final stage (much smaller image)
FROM alpine:latest

# Install ca-certificates for HTTPS requests (if needed)
RUN apk --no-cache add ca-certificates

# Create a non-root user for security
RUN addgroup -g 1001 appgroup && adduser -D -s /bin/sh -u 1001 -G appgroup appuser

# Set working directory
WORKDIR /home/appuser

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Change ownership to non-root user
RUN chown appuser:appgroup main

# Switch to non-root user
USER appuser

# Expose the port your app runs on
EXPOSE 8080

# Run the application
CMD ["./main"]
