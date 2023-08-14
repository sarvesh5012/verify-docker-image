FROM ubuntu

# Install Nginx
RUN apt-get -y update && apt-get -y install nginx

# Run the Nginx server
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]