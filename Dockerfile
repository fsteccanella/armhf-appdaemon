FROM balenalib/armv7hf-alpine-python:3.7.2-3.9-build AS builder

# Sets utf-8 encoding for Python et al
ENV LANG=C.UTF-8
# Turns off writing .pyc files; superfluous on an ephemeral container.
ENV PYTHONDONTWRITEBYTECODE=1
# Seems to speed things up
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

RUN [ "cross-build-start" ]

RUN python3 -m venv /venv
RUN /venv/bin/pip3 install --no-cache-dir appdaemon

RUN [ "cross-build-end" ]

FROM balenalib/armv7hf-alpine-python:3.7.2-3.9

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PATH="/venv/bin:$PATH"

COPY --from=builder /venv /venv

VOLUME /config
EXPOSE 5050

CMD appdaemon -c /config