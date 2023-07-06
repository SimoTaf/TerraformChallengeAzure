#!/bin/bash

# Update package repositories
sudo apt update

# Install Apache version 2 
sudo apt install -y apache2

# Editing the default index.html file 
echo ' this is my Vm(s) OK' > /var/www/html/index.html 
# Start Apache service
systemctl start apache2

# Enable Apache to start on boot
systemctl enable apache2
