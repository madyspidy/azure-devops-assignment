import os
from azure.monitor.opentelemetry import configure_azure_monitor

connection_string = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING")

if connection_string:
    configure_azure_monitor(
        connection_string=connection_string
    )

from flask import Flask

app = Flask(__name__)


@app.route("/")
def home():
    return "8byte DevOps Assignment - Application Running!"


@app.route("/health")
def health():
    return {"status": "healthy"}, 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)