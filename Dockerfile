# ── Stage 1 : Build Tailwind CSS ──────────────────────────────────────────────
FROM node:18-alpine AS frontend

WORKDIR /app

COPY package.json ./
RUN npm install

COPY tailwind.config.js ./
COPY static/src/ ./static/src/
COPY home/templates/ ./home/templates/
COPY jobs/templates/ ./jobs/templates/

RUN npm run build:css

# ── Stage 2 : Application Django ──────────────────────────────────────────────
FROM python:3.11-slim

WORKDIR /app

RUN pip install --upgrade pip

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Récupère le CSS compilé depuis le stage frontend
COPY --from=frontend /app/static/dist/ ./static/dist/

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["./entrypoint.sh"]
