ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

WORKDIR /app

RUN apk add --no-cache python3 py3-pip build-base libffi-dev

COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

COPY run.py .

CMD ["python3", "-u", "run.py"]
