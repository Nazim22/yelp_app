# Use Node 18 as the base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Accept MAPBOX_TOKEN as a build argument
ARG MAPBOX_TOKEN
# Make MAPBOX_TOKEN available as an environment variable at runtime
ENV MAPBOX_TOKEN=${MAPBOX_TOKEN}

# Expose application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
