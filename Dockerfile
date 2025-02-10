# Use Node 18 as the base image
FROM node:18

# Set working directory
WORKDIR /app

# Accept build arguments for Mapbox, DB, and Cloudinary
ARG MAPBOX_TOKEN
ARG DB_URL
ARG CLOUDINARY_CLOUD_NAME
ARG CLOUDINARY_KEY
ARG CLOUDINARY_SECRET

# Set environment variables for the app
ENV MAPBOX_TOKEN=$MAPBOX_TOKEN
ENV DB_URL=$DB_URL
ENV CLOUDINARY_CLOUD_NAME=$CLOUDINARY_CLOUD_NAME
ENV CLOUDINARY_KEY=$CLOUDINARY_KEY
ENV CLOUDINARY_SECRET=$CLOUDINARY_SECRET

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy all project files
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
