# STAGE 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# STAGE 2: Production Runtime
FROM nginx:stable-alpine
# Copy the custom nginx config we will create in Phase 4
# COPY proxy/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]