FROM balenalib/armv7hf-alpine-python:3.9-build AS builder

# Sets utf-8 encoding for Python et al
ENV LANG=C.UTF-8
# Turns off writing .pyc files; superfluous on an ephemeral container.
ENV PYTHONDONTWRITEBYTECODE=1
# Seems to speed things up
ENV PYTHONUNBUFFERED=1

# Ensures that the python and pip executables used
# in the image will be those from our virtualenv.
ENV PATH="/venv/bin:$PATH"

RUN [ "cross-build-start" ]

RUN apk add python3-dev
RUN pip3 install --no-cache-dir virtualenv
RUN python -m virtualenv /venv
RUN pip3 install --no-cache-dir appdaemon

RUN [ "cross-build-end" ]

FROM balenalib/armv7hf-alpine-python:3.9

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PATH="/venv/bin:$PATH"

COPY --from=builder /venv /venv

VOLUME /conf
EXPOSE 5050

CMD appdaemon -c /conf