# STAGE 1: Build Stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
# Install all dependencies (including devDeps if any)
RUN npm install
COPY . .

# Stage 2: Production
FROM node:18-slim
WORKDIR /app

# 1. Copy dependencies
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# 2. Copy the ENTIRE application directory
# This ensures all folders (routes, models, config, public) are present
COPY --from=builder /app ./

# 3. Permissions for the assets
RUN chmod -R 755 /app/public

EXPOSE 8080
CMD ["node", "server.js"]