# Stage 1: Nginx lightweight image
FROM nginx:stable-alpine

# Remove default Nginx index to prevent conflicts
RUN rm -rf /usr/share/nginx/html/*

# Copy only the build folder contents into Nginx web root
COPY build/ /usr/share/nginx/html

# Ensure proper permissions
RUN chmod -R 755 /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
