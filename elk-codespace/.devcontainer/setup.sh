#!/bin/bash
set -e

echo "============================================"
echo "  Setting up ELK Stack in Codespace"
echo "============================================"

# Wait for Docker to be ready
echo "[1/4] Waiting for Docker..."
while ! docker info > /dev/null 2>&1; do
  sleep 1
done
echo "       Docker is ready!"

# Set vm.max_map_count for Elasticsearch
echo "[2/4] Configuring system settings..."
sudo sysctl -w vm.max_map_count=262144 2>/dev/null || true

# Start ELK stack
echo "[3/4] Starting ELK Stack (this may take 2-3 minutes)..."
docker compose up -d

# Wait for Elasticsearch to be healthy
echo "[4/4] Waiting for Elasticsearch to be ready..."
until curl -s http://localhost:9200 > /dev/null 2>&1; do
  sleep 5
  echo "       Still waiting for Elasticsearch..."
done

echo ""
echo "============================================"
echo "  ELK Stack is running!"
echo "============================================"
echo ""
echo "  Elasticsearch : http://localhost:9200"
echo "  Kibana         : http://localhost:5601"
echo "  Logstash       : http://localhost:9600"
echo ""
echo "  Useful commands:"
echo "    docker compose logs -f        # View logs"
echo "    docker compose restart        # Restart all"
echo "    docker compose down           # Stop all"
echo "    docker compose down -v        # Stop + delete data"
echo ""
echo "  Quick test:"
echo "    curl http://localhost:9200/_cluster/health?pretty"
echo ""
echo "============================================"
