# build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent
COPY . .
RUN npm run build
# production stage
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
# remove default nginx config and ensure listen on 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
