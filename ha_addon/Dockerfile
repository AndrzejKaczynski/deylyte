ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base-python:3.12
FROM $BUILD_FROM

WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

COPY run.py .

CMD ["python3", "-u", "run.py"]
