# ELK Stack on GitHub Codespaces

Run Elasticsearch, Logstash, and Kibana entirely in the cloud — zero load on your local machine.

## Quick Start

### Step 1: Create the GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. Name it `elk-codespace` (or any name you like)
3. Set it to **Private** (recommended)
4. Click **Create repository**

### Step 2: Push These Files

```bash
git init
git add .
git commit -m "Initial ELK Codespace setup"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/elk-codespace.git
git push -u origin main
```

### Step 3: Launch the Codespace

1. Go to your repo on GitHub
2. Click the green **Code** button
3. Select the **Codespaces** tab
4. Click **Create codespace on main**
5. **Important**: Select a **4-core** machine (16 GB RAM) when prompted

The setup script will automatically:
- Start Docker
- Pull the ELK images
- Launch all three services
- Wait until everything is healthy

This takes about **3-5 minutes** on first launch.

### Step 4: Access Your Services

Once setup completes, Codespaces will show forwarded ports in the **Ports** tab:

| Service         | Port | What It Does                    |
|-----------------|------|---------------------------------|
| Elasticsearch   | 9200 | Search & storage API            |
| Kibana          | 5601 | Web dashboard (opens in browser)|
| Logstash Beats  | 5044 | Receive logs from Beats agents  |
| Logstash Monitor| 9600 | Logstash health monitoring      |

Click the **globe icon** next to port 5601 to open Kibana in your browser.

## Sending Logs

### Send a test log via TCP

```bash
echo '{"app":"myapp","level":"info","msg":"Test log entry"}' | nc localhost 5000
```

### Verify in Elasticsearch

```bash
curl http://localhost:9200/logs-*/_search?pretty
```

### View in Kibana

1. Open Kibana (port 5601)
2. Go to **Management → Stack Management → Index Patterns**
3. Create pattern: `logs-*`
4. Go to **Discover** to see your logs

## Managing the Stack

```bash
# View real-time logs
docker compose logs -f

# Restart everything
docker compose restart

# Stop everything (keeps data)
docker compose down

# Stop and delete all data
docker compose down -v

# Check cluster health
curl http://localhost:9200/_cluster/health?pretty
```

## Cost Management

- GitHub Free: **60 hours/month** on 2-core machines
- A 4-core machine uses **2x the hours** (so ~30 hours of actual usage)
- **Always stop your Codespace** when not using it:
  - Go to [github.com/codespaces](https://github.com/codespaces)
  - Click the **...** menu → **Stop codespace**
- Codespaces auto-stop after 30 minutes of inactivity

## File Structure

```
elk-codespace/
├── .devcontainer/
│   ├── devcontainer.json    # Codespace configuration
│   └── setup.sh             # Auto-setup script
├── docker-compose.yml       # ELK service definitions
├── logstash/
│   ├── config/
│   │   └── logstash.yml     # Logstash settings
│   └── pipeline/
│       └── logstash.conf    # Log processing pipeline
└── README.md
```

## Customizing

- **Add more Logstash pipelines**: Add `.conf` files to `logstash/pipeline/`
- **Change Elasticsearch settings**: Edit environment variables in `docker-compose.yml`
- **Increase resources**: Edit `ES_JAVA_OPTS` and `LS_JAVA_OPTS` in `docker-compose.yml`
