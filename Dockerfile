FROM python:3.12-slim AS builder
RUN mkdir /app
WORKDIR /app

# Prevents Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
# Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1 

RUN pip install --upgrade pip
 
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim
# We don't want to run as root so we create a new user and make them own the /app directory
RUN useradd -m -r appuser && \
    mkdir /app && \
    chown -R appuser /app

COPY --from=builder /usr/local/lib/python3.12/site-packages/ /usr/local/lib/python3.12/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/    

WORKDIR /app

# We take ownership of the copied directory
COPY --chown=appuser:appuser project_tracker .

# Prevents Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
# Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1 

USER appuser

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "project_tracker.wsgi:application"]