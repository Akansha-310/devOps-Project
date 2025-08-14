# 🧱 Stage 1: Build environment
# Use Node 18 LTS to ensure compatibility with react-scripts and postcss
FROM node:18.20-alpine as build

WORKDIR /app

# Copy only package.json + yarn.lock first for better layer caching
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn

# Now copy the rest of the app
COPY . .

# Build the React app
RUN yarn build

# 🌐 Stage 2: Production environment
FROM nginx:stable-alpine

# Copy built frontend app from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy your custom nginx config (make sure this path exists)
COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
