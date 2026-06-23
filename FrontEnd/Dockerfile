# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM node:20-alpine AS build
WORKDIR /app

# Instala dependências (camada cacheada)
COPY package.json package-lock.json* ./
RUN npm ci

# Copia código e gera build de produção
COPY . .

# VITE_API_URL é injetado em build-time via ARG
ARG VITE_API_URL=http://localhost:8080
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build

# ── Stage 2: Nginx ─────────────────────────────────────────────────────────────
FROM nginx:alpine AS runtime

# Remove config padrão do nginx
RUN rm /etc/nginx/conf.d/default.conf

# Config customizada para SPA (React Router)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia o build gerado
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
