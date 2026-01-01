# Use Node.js LTS version
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Install TypeScript globally
RUN npm install -g typescript

# Copy source code
COPY . .

# Compile TypeScript
RUN tsc

# Expose the default port (can be overridden by environment variable)
EXPOSE 8080

# Set default environment variables
ENV NODE_ENV=production

# Run the proxy
CMD ["node", "build/index.js"]
