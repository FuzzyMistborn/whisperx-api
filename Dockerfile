FROM ghcr.io/jim60105/whisperx:no_model AS base

ARG UID=1001
USER root

# ===== Final stage =====
FROM base

RUN /venv/bin/pip install --no-cache-dir fastapi uvicorn python-multipart srt webvtt-py

RUN python -m nltk.downloader -d /usr/local/share/nltk_data punkt_tab

# Copy the API code
COPY app.py /whisperx/app.py

# Expose the API port
EXPOSE 8000

# Set the environment and entrypoint
ENV PATH="/venv/bin:${PATH}"
ENV XDG_CACHE_HOME=/root/.cache
ENV HUGGINGFACE_HUB_CACHE=/root/.cache/huggingface/hub
ENV HF_HOME=/root/.cache/huggingface
ENV TORCH_HOME=/root/.cache/torch

WORKDIR /whisperx
ENTRYPOINT ["python", "-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
