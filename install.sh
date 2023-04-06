#!/bin/bash 
echo "Please run this as root"
echo "This installer will do the following:"
echo ""
echo "- Install Node-RED"
echo "- Install Docker"
echo "- Install Dnsmasq"
echo "- Launch Webserver via Docker"
echo "- Launch Node-RED"
echo "- Copy the following files from the Installation folder..."
echo "-- hosts"
echo "-- dnsmasq.config"
echo "-- Rotary Phone.nmconnection"
echo ""




# Install Node-RED
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
sudo systemctl enable nodered
sudo systemctl start nodered




# Install Docker Engine
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker pi





# Copy Files
sudo cp Installation/hosts /etc/hosts
sudo chown root:root /etc/hosts
sudo chmod 644:644 /etc/hosts

sudo cp Installation/dnsmasq.conf /etc/dnsmasq.conf
sudo chown root:root /etc/dnsmasq.conf
sudo chmod 644:644 /etc/dnsmasq.conf

sudo cp Installation/Rotary\ Phone.nmconnection /etc/NetworkManager/system-connections/Rotary\ Phone.nmconnection
sudo chown root:root /etc/NetworkManager/system-connections/Rotary\ Phone.nmconnection
sudo chmod 600:600 /etc/NetworkManager/system-connections/Rotary\ Phone.nmconnection


sudo cp rotary/ /rotary
sudo chmod 777 /rotary


# Install Web Server
sudo docker compose -f /rotary/server/webserver/docker-compose.yml up -d
