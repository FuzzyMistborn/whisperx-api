FROM ghcr.io/jim60105/whisperx:no_model

USER root

RUN /venv/bin/python3 -m ensurepip && \
    /venv/bin/python3 -m pip install --no-cache-dir fastapi uvicorn python-multipart srt webvtt-py && \
    /venv/bin/python3 -m pip uninstall -y pip

RUN python3 -m nltk.downloader -d /usr/local/share/nltk_data punkt_tab

COPY app.py /whisperx/app.py

EXPOSE 8000

ENV PATH="/venv/bin:${PATH}"
ENV XDG_CACHE_HOME=/.cache
ENV HUGGINGFACE_HUB_CACHE=/.cache/huggingface/hub
ENV HF_HOME=/.cache/huggingface
ENV TORCH_HOME=/.cache/torch

WORKDIR /whisperx
ENTRYPOINT ["python3", "-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
