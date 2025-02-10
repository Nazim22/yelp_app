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

# Accept MAPBOX_TOKEN and DB_URL as build arguments
ARG MAPBOX_TOKEN
ARG DB_URL

# Make these values available at runtime
ENV MAPBOX_TOKEN=${MAPBOX_TOKEN}
ENV DB_URL=${DB_URL}

# Expose application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
