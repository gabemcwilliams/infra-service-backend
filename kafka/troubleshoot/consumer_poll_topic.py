from kafka import KafkaConsumer
import json
import time

# Initialize Kafka Consumer
consumer = KafkaConsumer(
    'topic2',  # Topic to consume messages from
    bootstrap_servers='kafka.example.internal:9092',  # Kafka broker address
    auto_offset_reset='earliest',  # Start from the earliest message if no offset is found
    group_id='test-group',  # Consumer group ID
)

# Polling loop: every 5 seconds
try:
    while True:
        print('Attempting to poll messages...')

        # Poll for new messages from Kafka (block for 5 seconds)
        messages = consumer.poll(timeout_ms=5000)  # 5000 ms = 5 seconds
        print('timed out')
        # Check if there are new messages
        if messages:
            print('Messages found!')
            for topic_partition, records in messages.items():
                for record in records:
                    print(f"Raw message (hex): {record.value}")  # Print the raw message in hex
                    try:
                        # Try decoding the hex message to a string
                        decoded_message = record.value.decode('utf-8')
                        print(f"Decoded message: {decoded_message}")
                        # Optionally, parse as JSON
                        json_message = json.loads(decoded_message)
                        print(f"JSON message: {json_message}")
                    except Exception as e:
                        print(f"Error decoding message: {e}")
        else:
            print("No new messages, retrying...")  # No new messages, will retry after 5 seconds
            time.sleep(1)  # Optional: Add a short sleep to avoid hammering Kafka

except KeyboardInterrupt:
    print("Consumer stopped.")
finally:
    consumer.close()  # Close the consumer connection when done
