# Use the official Nginx image to serve static files
FROM nginx:alpine

# Copy all static files from your project directory to Nginx HTML folder
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
