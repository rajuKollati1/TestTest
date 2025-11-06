
# Dockerfile
# Located at apps/coconut-business/Dockerfile

# Use the official lightweight Nginx image as the base
FROM nginx:alpine

# Remove the default Nginx welcome page
RUN rm /usr/share/nginx/html/index.html

# Copy your custom HTML page into the Nginx web root
# NOTE: The source file name is assumed to be 'coconut.html' 
# and it is renamed to 'index.html' which Nginx serves by default.
COPY apps/Medicalshop/medicalshop.html /usr/share/nginx/html/index.html

# Expose port 80 (default HTTP port for Nginx)
EXPOSE 80

# Command to run Nginx in the foreground (default Nginx behavior)
CMD ["nginx", "-g", "daemon off;"]
