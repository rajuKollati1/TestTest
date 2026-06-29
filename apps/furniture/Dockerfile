# Use the standard Debian-based Nginx image
FROM nginx:latest

# Clean out the default Nginx landing files completely
RUN rm -rf /usr/share/nginx/html/*

# Copy your local index.html directly into the clean directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80