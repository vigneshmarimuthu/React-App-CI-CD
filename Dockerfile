# Use a lightweight and stable Nginx version
FROM nginx:stable-alpine

# Remove the default Nginx index.html to prevent conflicts
RUN rm /usr/share/nginx/html/index.html

# Copy all files from the current directory (your compiled app) 
# into the Nginx web root directory
COPY . /usr/share/nginx/html

# Expose the standard HTTP port 
EXPOSE 80

# The default Nginx command will run, serving your files
# CMD ["nginx", "-g", "daemon off;"]
