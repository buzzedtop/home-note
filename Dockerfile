# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:3.16.0 AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build for web
RUN flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built web app from build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
