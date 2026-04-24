# STAGE 1: Build Stage
# Use a Node image to install dependencies
FROM node:18-alpine AS builder

# Create app directory
WORKDIR /usr/src/app

# Copy package files and install production dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy the rest of the application source code
COPY . .

# ---

# STAGE 2: Runtime Stage
# Use a fresh, tiny Alpine image for the final container
FROM node:18-alpine

# Set environment to production
ENV NODE_ENV=production
WORKDIR /usr/src/app

# Copy ONLY the node_modules and code from the builder stage
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app .

# Expose the app's internal port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]