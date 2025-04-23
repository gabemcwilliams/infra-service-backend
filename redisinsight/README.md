## 🔍 RedisInsight Service Overview

RedisInsight is a GUI for Redis. That’s it. It looks pretty and helps you not completely destroy your Redis data by
accident. Great for local dev, demos, or pretending to be a DBA.

---

### ⚙️ Service Configuration

| Setting            | Value                    |
|--------------------|--------------------------|
| Image              | `redislabs/redisinsight` |
| Web UI Port        | `5540`                   |
| Container Hostname | `redisinsight`           |
| Connects To Redis  | `[REDACTED_IP]:6379`         |
| Volume             | `redis-insight`          |
| Network            | `redis`                  |
| IP Address         | `[REDACTED_IP]`              |

---

### 🐳 Docker Compose Snippet

```yaml
services:
  redisinsight:
    image: redislabs/redisinsight:latest
    container_name: redisinsight
    ports:
      - "5540:5540"
    environment:
      - REDISINSIGHT_HOST=[REDACTED_IP]
      - REDISINSIGHT_PORT=6379
    networks:
      redis:
        ipv4_address: [REDACTED_IP]
    volumes:
      - redis-insight:/data
    restart: unless-stopped

volumes:
  redis-insight:

networks:
  redis:
    name: redis
    driver: bridge
    ipam:
      config:
        - subnet: "[REDACTED_IP]/24"
```

---

### 🛠 How to Use It

1. Start the container (`docker-compose up -d`, obviously).
2. Open your browser and go to: [http://localhost:5540](http://localhost:5540)
3. Connect it to your Redis instance at `[REDACTED_IP]:6379` (or whatever your Redis is actually doing).
4. Click things. Visualize. Pretend you're debugging.

---

### 🛑 Warnings

- **Not secured.** No password, no auth, just vibes. Don’t expose this thing to the outside world unless you like risk.
- It stores configs and insights in `/data`, which is persisted via the `redis-insight` volume.

---

### 💡 Pro Tips

- Great for visualizing keys, TTLs, memory usage, and debugging weirdness.
- Pair this with a local Redis running in the same network (`[REDACTED_IP]`) for clean integration.
- If RedisInsight can't connect, it’s probably your firewall, Docker network misconfig, or because you left the Redis
  container in a coma.
