# Yelp Camp Web Application

This web application allows users to add, view, access, and rate campgrounds by location. It is based on "The Web Developer Bootcamp" by Colt Steele, but includes several modifications and bug fixes. The application leverages a variety of technologies and packages, such as:

- **Node.js with Express**: Used for the web server.
- **Bootstrap**: For front-end design.
- **Mapbox**: Provides a fancy cluster map.
- **MongoDB Atlas**: Serves as the database.
- **Passport package with local strategy**: For authentication and authorization.
- **Cloudinary**: Used for cloud-based image storage.
- **Helmet**: Enhances application security.
- ...

## Setup Instructions

To get this application up and running, you'll need to set up accounts with Cloudinary, Mapbox, and MongoDB Atlas. Once these are set up, create a `.env` file in the same folder as `app.js`. This file should contain the following configurations:

```sh
CLOUDINARY_CLOUD_NAME=[Your Cloudinary Cloud Name]
CLOUDINARY_KEY=[Your Cloudinary Key]
CLOUDINARY_SECRET=[Your Cloudinary Secret]
MAPBOX_TOKEN=[Your Mapbox Token]
DB_URL=[Your MongoDB Atlas Connection URL]
SECRET=[Your Chosen Secret Key] # This can be any value you prefer
```

After configuring the .env file, you can start the project by running:
```sh
docker compose up
```

## Application Screenshots
![](./images/home.jpg)
![](./images/campgrounds.jpg)
![](./images/register.jpg)



YelpCamp - 3-Tier Full Stack Deployment 🚀
📌 Project Overview
This repository contains a 3-Tier Full Stack Web Application named YelpCamp, built using:

Frontend: EJS & Bootstrap
Backend: Node.js, Express.js
Database: MongoDB Atlas
Cloud Storage: Google Cloud Storage (Replaces Cloudinary)
Geolocation & Maps: Mapbox API
This README guides you through cloning, building, scanning, pushing Docker images, and deploying the app via GitHub Actions.

🏗️ Project Setup
1️⃣ Clone the Repository
sh
Copy
Edit
git clone https://github.com/yourusername/yelp-app.git
cd yelp-app
2️⃣ Install Dependencies
Ensure you have Node.js (v18) installed.

sh
Copy
Edit
npm install
3️⃣ Setup Environment Variables
Create a .env file at the root directory and add:

ini
Copy
Edit
MAPBOX_TOKEN=your_mapbox_token
DB_URL=your_mongodb_atlas_url
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_KEY=your_cloudinary_key
CLOUDINARY_SECRET=your_cloudinary_secret
🐳 Dockerization
4️⃣ Build and Run Docker Container Locally
sh
Copy
Edit
docker build -t your-dockerhub-username/yelp-app:latest \
  --build-arg MAPBOX_TOKEN=your_mapbox_token \
  --build-arg DB_URL=your_mongodb_atlas_url \
  --build-arg CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name \
  --build-arg CLOUDINARY_KEY=your_cloudinary_key \
  --build-arg CLOUDINARY_SECRET=your_cloudinary_secret .
5️⃣ Run the Container
sh
Copy
Edit
docker run -d -p 3000:3000 --name yelp-app \
  --env-file .env \
  your-dockerhub-username/yelp-app:latest
6️⃣ Verify Application
Check logs:

sh
Copy
Edit
docker logs yelp-app
Access the app at: http://localhost:3000

🤖 GitHub Actions Workflow
The CI/CD pipeline automates the following:

Checkout the code 🛠️
Install dependencies 📦
Run SonarQube Code Analysis 🔍
Build the Docker Image 🐳
Scan the Image using Trivy 🛡️
Push the Image to DockerHub 🚀
Test the container run 🧪
🔍 CI/CD Workflow Explained
7️⃣ GitHub Secrets
Before running the pipeline, add the following secrets in your GitHub repository:

DOCKERHUB_USERNAME
DOCKERHUB_PASSWORD
MAPBOX_TOKEN
DB_URL
CLOUDINARY_CLOUD_NAME
CLOUDINARY_KEY
CLOUDINARY_SECRET
SONAR_TOKEN
SONAR_HOST_URL
8️⃣ Full Workflow File
yaml
Copy
Edit
name: CI/CD Workflow

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  checkout:
    name: 📥 Checkout Repository
    runs-on: self-hosted
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

  build:
    name: 🛠 Build and Install Dependencies
    runs-on: self-hosted
    needs: checkout
    steps:
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm install

  code-scan:
    name: 🔍 SonarQube Code Analysis
    runs-on: self-hosted
    needs: build
    steps:
      - name: Run SonarQube Code Scan
        uses: SonarSource/sonarqube-scan-action@v4
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          projectBaseDir: .
          args: >
            -Dsonar.projectKey=yelp-app
            -Dsonar.organization=my-org
            -Dsonar.host.url=${{ secrets.SONAR_HOST_URL }}

  docker_build:
    name: 🐳 Build Docker Image with Secrets
    runs-on: self-hosted
    needs: code-scan
    steps:
      - name: Build Docker Image
        run: |
          docker build -t ${{ secrets.DOCKERHUB_USERNAME }}/yelp-app:latest \
            --build-arg MAPBOX_TOKEN="${{ secrets.MAPBOX_TOKEN }}" \
            --build-arg DB_URL="${{ secrets.DB_URL }}" \
            --build-arg CLOUDINARY_CLOUD_NAME="${{ secrets.CLOUDINARY_CLOUD_NAME }}" \
            --build-arg CLOUDINARY_KEY="${{ secrets.CLOUDINARY_KEY }}" \
            --build-arg CLOUDINARY_SECRET="${{ secrets.CLOUDINARY_SECRET }}" .

  trivy_scan:
    name: 🛡️ Trivy Security Scan
    runs-on: self-hosted
    needs: docker_build
    steps:
      - name: Scan Docker Image with Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'docker.io/${{ secrets.DOCKERHUB_USERNAME }}/yelp-app:latest'
          format: 'table'
          severity: 'HIGH,CRITICAL'

  docker_push:
    name: 🚀 Push Docker Image to Docker Hub
    runs-on: self-hosted
    needs: trivy_scan
    steps:
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_PASSWORD }}

      - name: Push Docker Image
        run: docker push ${{ secrets.DOCKERHUB_USERNAME }}/yelp-app:latest

  test_run:
    name: 🧪 Run and Test Container
    runs-on: self-hosted
    needs: docker_push
    steps:
      - name: Create .env File
        run: |
          echo "MAPBOX_TOKEN=${{ secrets.MAPBOX_TOKEN }}" >> .env
          echo "DB_URL=${{ secrets.DB_URL }}" >> .env
          echo "CLOUDINARY_CLOUD_NAME=${{ secrets.CLOUDINARY_CLOUD_NAME }}" >> .env
          echo "CLOUDINARY_KEY=${{ secrets.CLOUDINARY_KEY }}" >> .env
          echo "CLOUDINARY_SECRET=${{ secrets.CLOUDINARY_SECRET }}" >> .env

      - name: Remove Existing Container if Present
        run: |
          if [ $(docker ps -aq -f name=yelp-app) ]; then
            echo "Stopping and removing existing container..."
            docker stop yelp-app || true
            docker rm yelp-app || true
          else
            echo "No existing container found."
          fi

      - name: Run the Docker Container with .env File
        run: |
          docker run -d -p 3000:3000 --name yelp-app \
            --env-file .env \
            docker.io/${{ secrets.DOCKERHUB_USERNAME }}/yelp-app:latest

      - name: Verify Application Logs
        run: docker logs yelp-app

      - name: Test Application Health Check with Retry Logic
        run: |
          for i in {1..10}; do
            echo "Checking if application is up... Attempt $i"
            curl --fail http://localhost:3000 && break || sleep 5
          done