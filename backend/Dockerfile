# STAGE 1: Build/Install
FROM node:18-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# If your app needs a build step (e.g., TypeScript), add it here:
# RUN npm run build

# STAGE 2: Production Lean Runtime
FROM node:18-alpine
WORKDIR /app
# Only copy the production dependencies
COPY package*.json ./
RUN npm install --only=production
# Copy only the necessary source/build files from the build stage
COPY --from=build-stage /app .

EXPOSE 5000
CMD ["npm", "start"]