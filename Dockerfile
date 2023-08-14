# Use a small base image
FROM alpine:3.14

# Install Apache
RUN apk --no-cache add apache2

# Expose the default Apache port
EXPOSE 80

# Start Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND"]
