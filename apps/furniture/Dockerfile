# Use the official lightweight Nginx image as the base
FROM nginx:alpine

# The Nginx image is based on Alpine Linux, which is very small.
# We don't need a multi-stage build since the source file is already complete HTML.

# Remove the default Nginx index.html file
RUN rm /usr/share/nginx/html/index.html

# Copy the existing HTML file (furniture.html) into the Nginx web root directory
# This makes your "High-Level Furniture Store Front Page" the default content.
# Updated source filename from index.html to furniture.html
COPY apps/furniture/index.html /usr/share/nginx/html/index.html 

# Expose port 80, which is the default port Nginx listens on
EXPOSE 80

# Nginx starts automatically when the container is run (default CMD for nginx:alpine)
# To build and run:
# 1. Build: docker build -t furniture-store .
# 2. Run: docker run -p 8080:80 furniture-store
