from fastapi import FastAPI, HTTPException
from kafka import KafkaProducer
import json

# Initialize the FastAPI app
app = FastAPI()

# Initialize the KafkaProducer
producer = KafkaProducer(
    bootstrap_servers='kafka.example.internal:9092',
    acks='all',
    batch_size=32768,
    linger_ms=5,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serialize to JSON before sending
)

# Kafka topic
TOPIC = 'topic2'


# Send the received data to Kafka
def send_message_to_kafka(data, topic=TOPIC):
    """Function to send a structured message to Kafka."""
    message = {
        "topic": topic,
        "data": data
    }

    try:
        producer.send(topic, value=message)
        producer.flush()  # Ensure the message is sent
        print(f"Sent: {message}")
    except Exception as e:
        print(f"Error sending message to Kafka: {e}")
        raise HTTPException(status_code=500, detail="Error sending message to Kafka")


# FastAPI route to receive data and pass it to Kafka
@app.post("/send-data/")
async def send_data(data: dict):
    """Receive data from the client and send it to Kafka."""
    if not data:
        raise HTTPException(status_code=400, detail="No data provided")
    print(f"Received data: {data}")  # Log what data you're receiving
    send_message_to_kafka(data)
    print("Message sent to Kafka.")
    return {"message": "Data sent to Kafka successfully"}


# Graceful shutdown to close the KafkaProducer
@app.on_event("shutdown")
def shutdown_event():
    """Close Kafka producer gracefully when FastAPI app shuts down."""
    print("Shutting down Kafka producer...")
    producer.close()  # Close the producer to release resources


# To run the FastAPI app, use: uvicorn your_script_name:app --reload
import uvicorn

if __name__ == "__main__":
    uvicorn.run(app, host="[REDACTED_IP]", port=8000)
