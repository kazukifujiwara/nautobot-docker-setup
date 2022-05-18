# nautobot-docker-setup

This is a script to start nautobot on an instance with no configuration.

## Tested Environment

### Environments

* Ubuntu 20.04.4

## Settings

An administrator user is created by default. (Username: admin / Password: admin)

If you want to change the default settings, you need to override "local.env".

If not changed, nautobot can be accessed on port 8080.

## Plugins

* nautobot-device-onboarding
* nautobot_plugin_nornir
* nautobot_golden_config

## Reference

* [nautobot-docker-compose](https://github.com/nautobot/nautobot-docker-compose)

