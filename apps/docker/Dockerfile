# Use a lightweight NGINX base image
FROM nginx:alpine

# Copy the HTML file from the repository root, relative to the build context.
# Source: apps/web/index.html (in the checked-out repo)
# Destination: /usr/share/nginx/html/ (default NGINX content directory)
COPY apps/web/index.html /usr/share/nginx/html/index.html

# Expose the default HTTP port
EXPOSE 80
