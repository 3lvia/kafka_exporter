FROM golang as build
WORKDIR /
COPY . .
RUN go build



FROM debian:stable-slim as app

### Get Python, PIP
RUN apt-get update \
    && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get -y upgrade

RUN addgroup appuser --gid 1001 \
    && adduser appuser --uid 1001 \
        --ingroup appuser \
        --disabled-password
RUN mkdir /logs && chown -R appuser:appuser /logs


COPY --from=build --chown=appuser:appuser /kafka_exporter /opt/bin/kafka_exporter
COPY start.py /opt/bin/start.py

RUN python3 -m venv /opt/venv
COPY requirements.txt .
RUN . /opt/venv/bin/activate && pip3 install -r requirements.txt

WORKDIR /opt
RUN chown -R appuser:appuser /opt
RUN chmod u+x /opt/bin/kafka_exporter

USER appuser
CMD . /opt/venv/bin/activate && python3 /opt/bin/start.py
