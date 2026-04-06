#!/bin/bash
set -e

echo "============================================"
echo "  Setting up ELK Stack (BOTSv1) in Codespace"
echo "============================================"

# Wait for Docker to be ready
echo "[1/5] Waiting for Docker..."
while ! docker info > /dev/null 2>&1; do
  sleep 1
done
echo "       Docker is ready!"

# Set vm.max_map_count for Elasticsearch
echo "[2/5] Configuring system settings..."
sudo sysctl -w vm.max_map_count=262144 2>/dev/null || true

# Check for BOTSv1 data files
echo "[3/5] Checking for BOTSv1 data files..."
if [ -d "data/bots-v1" ] && [ "$(ls -A data/bots-v1/*.json 2>/dev/null)" ]; then
  echo "       Found BOTSv1 JSON files:"
  ls -lh data/bots-v1/*.json
else
  echo ""
  echo "  ⚠  No BOTSv1 JSON files found in data/bots-v1/"
  echo "  ⚠  Upload your JSON files to data/bots-v1/ before starting Logstash"
  echo "  ⚠  Expected files:"
  echo "       - botsv1.iis.json"
  echo "       - botsv1.fgt_event.json"
  echo "       - botsv1.stream_http.json"
  echo "       - botsv1.winregistry.json"
  echo "       - botsv1.XmlWinEventLog_Microsoft-Windows-Sysmon-Operational.json"
  echo "       - botsv1.suricata.json"
  echo ""
fi

# Start ELK stack
echo "[4/5] Starting ELK Stack (this may take 3-5 minutes on first run)..."
docker compose up -d

# Wait for Elasticsearch to be healthy
echo "[5/5] Waiting for Elasticsearch to be ready..."
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
echo "  To upload BOTSv1 data:"
echo "    1. Put JSON files in data/bots-v1/"
echo "    2. Restart Logstash: docker compose restart logstash"
echo ""
echo "  Useful commands:"
echo "    docker compose logs -f logstash   # Watch ingestion"
echo "    docker compose restart logstash   # Restart after adding data"
echo "    docker compose down               # Stop all"
echo "    docker compose down -v            # Stop + delete all data"
echo ""
echo "  Check indices:"
echo "    curl http://localhost:9200/_cat/indices?v"
echo ""
echo "============================================"
