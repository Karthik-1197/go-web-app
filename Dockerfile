# Build stage
FROM golang:1.22.5 as base

WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod .
RUN go mod download

# Copy all source code
COPY . .

# Build the Go binary
RUN go build -o main .

# ---------------------------------------------------------
# Final stage - Distroless image
FROM gcr.io/distroless/base

WORKDIR /app

# Copy binary from build stage
COPY --from=base /app/main .

# Copy static files
COPY --from=base /app/static ./static

# Expose port
EXPOSE 8080

# Run the application
CMD ["./main"]
