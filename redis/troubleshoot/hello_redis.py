import redis

# Define Redis host and port
redis_host = '[REDACTED_IP]'  # Use IP or DNS name from Docker's extra_hosts or Nginx
redis_port = 6379

try:
    # Connect to Redis
    r = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)

    # Test: Set and retrieve a key
    r.set('test_key', 'Hello, Redis!')
    value = r.get('test_key')

    if value == 'Hello, Redis!':
        print("✅ Redis connection successful!")
    else:
        print(f"⚠️ Unexpected value: {value}")

except Exception as e:
    print(f"❌ Error connecting to Redis: {e}")

finally:
    if r:
        try:
            r.close()
        except Exception:
            pass
