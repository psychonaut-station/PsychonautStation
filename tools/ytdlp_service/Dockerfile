FROM denoland/deno:bin-2.9.8 AS deno

FROM python:3.14-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# yt-dlp solves YouTube's JavaScript challenges with deno, the only runtime it enables by default
COPY --from=deno /deno /usr/local/bin/deno

# [default] has the yt-dlp-ejs version this yt-dlp release expects
RUN pip install --no-cache-dir --break-system-packages \
    "yt-dlp[default]"

COPY app.py /app/app.py

RUN groupadd appuser && \
    useradd -g appuser -d /app -s /bin/bash appuser && \
    chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

CMD ["python", "/app/app.py"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1
