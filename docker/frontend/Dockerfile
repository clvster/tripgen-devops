# syntax=docker/dockerfile:1

FROM node:20-alpine AS builder

LABEL maintainer="Cluster Orlaith"

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --prefer-offline

COPY . .
RUN npm run build

FROM nginx:1.27-alpine

ENV ENVIRONMENT=stage

RUN rm /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

