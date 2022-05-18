#/bin/bash
sudo apt -y update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose

git clone https://github.com/nautobot/nautobot-docker-compose.git
cd nautobot-docker-compose
cp local.env.example local.env

# If you don't want to create "admin" user with default setting, comment out the following.
sed -i -e "s/NAUTOBOT_CREATE_SUPERUSER=false/NAUTOBOT_CREATE_SUPERUSER=true/g" local.env

chmod 0600 local.env

tee plugin_requirements.txt <<EOF
nautobot-device-onboarding
EOF

tee Dockerfile-Plugins <<EOF
ARG PYTHON_VER
ARG NAUTOBOT_VERSION=1.2.8
FROM networktocode/nautobot:\${NAUTOBOT_VERSION}-py\${PYTHON_VER}

COPY ./plugin_requirements.txt /opt/nautobot/
RUN pip install --no-warn-script-location -r /opt/nautobot/plugin_requirements.txt

COPY config/nautobot_config.py /opt/nautobot/nautobot_config.py
EOF

tee docker-compose.override.yml <<EOF
---
version: "3.7"
services:
  nautobot:
    image: "nautobot-plugins:latest"
    build:
      context: "."
      dockerfile: "Dockerfile-Plugins"
      args:
        PYTHON_VER: "\${PYTHON_VER:-3.9}"
    env_file:
      - "local.env"
    ports:
      - "8443:8443"
      - "8080:8080"
    restart: "unless-stopped"
  nautobot-worker:
    image: "nautobot-plugins:latest"
    build:
      context: "."
      dockerfile: "Dockerfile-Plugins"
      args:
        PYTHON_VER: "\${PYTHON_VER:-3.9}"
    env_file:
      - "local.env"
    restart: "unless-stopped"
  celery_worker:
    image: "nautobot-plugins:latest"
    build:
      context: "."
      dockerfile: "Dockerfile-Plugins"
      args:
        PYTHON_VER: "\${PYTHON_VER:-3.9}"
    env_file:
      - "local.env"
    restart: "unless-stopped"
EOF

cp plugin_example/config/nautobot_config.py config/nautobot_config.py
tee -a config/nautobot_config.py <<EOF
# Enable installed plugins. Add the name of each plugin to the list.
PLUGINS = ["nautobot_device_onboarding"]
# Plugins configuration settings. These settings are used by various plugins that the user may have installed.
# Each key in the dictionary is the name of an installed plugin and its value is a dictionary of settings.
PLUGINS_CONFIG = {}
EOF


# The following should be changed for proper security!
# vi local.env

sudo docker-compose up -d