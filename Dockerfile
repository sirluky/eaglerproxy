# Use Node.js LTS version
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Install TypeScript globally (pinned version for compatibility)
RUN npm install -g typescript@5.0.4

# Copy source code
COPY . .

# Compile TypeScript (skip type checking for Buffer compatibility issues)
RUN tsc --skipLibCheck

# Expose the default port (can be overridden by environment variable)
EXPOSE 8080

# Set default environment variables
ENV NODE_ENV=production

# Run the proxy
CMD ["node", "build/index.js"]
