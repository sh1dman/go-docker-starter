# Go Docker Starter Makefile

.PHONY: test build run clean docker-build docker-up docker-down docker-logs pre-push pre-push-docker help

# Run tests
test:
	@echo "Running tests..."
	go test ./...

# Build the application
build:
	@echo "Building application..."
	@mkdir -p bin
	go build -o bin/server ./cmd/server

# Run the application
run: build
	@echo "Starting server..."
	./bin/server

# Clean build artifacts
clean:
	@echo "Cleaning up..."
	rm -rf bin/
	rm -f server
	docker compose down 2>/dev/null || true
	docker rm go-server 2>/dev/null || true

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t go-docker-starter .

# Start with docker-compose
docker-up:
	@echo "Starting with docker-compose..."
	docker compose up --build

# Stop docker-compose
docker-down:
	@echo "Stopping docker-compose..."
	docker compose down

# View docker-compose logs
docker-logs:
	@echo "Viewing docker-compose logs..."
	docker compose logs -f

# Run all checks before pushing (recommended workflow)
pre-push: clean test build
	@echo "✅ All checks passed! Safe to push."

# Run all checks including Docker build (requires Docker permissions)
pre-push-docker: clean test build docker-build
	@echo "✅ All checks including Docker passed! Safe to push."

# Help command
help:
	@echo "Available commands:"
	@echo "  make test         - Run tests"
	@echo "  make build        - Build the application"
	@echo "  make run          - Build and run the application"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-up    - Start with docker-compose"
	@echo "  make docker-down  - Stop docker-compose"
	@echo "  make docker-logs  - View docker-compose logs"
	@echo "  make pre-push     - Run all checks (recommended before git push)"
