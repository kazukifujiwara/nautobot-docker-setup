# nautobot-docker-setup

This is a script to start nautobot on an instance with no configuration.

## Tested Environment

### Ubuntu

```
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=22.04
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Ubuntu 22.04 LTS"
```

## Settings

An administrator user is created by default. (Username: admin / Password: admin)

If you want to change the default settings, you need to override "local.env".

If not changed, nautobot can be accessed on port 8080.

```
$ sudo docker-compose ps
                  Name                                 Command                   State                                  Ports                           
--------------------------------------------------------------------------------------------------------------------------------------------------------
nautobot-docker-compose_celery_beat_1       sh -c nautobot-server cele ...   Up (unhealthy)                                                             
nautobot-docker-compose_celery_worker_1     sh -c nautobot-server cele ...   Up (unhealthy)                                                             
nautobot-docker-compose_db_1                docker-entrypoint.sh postgres    Up               5432/tcp                                                  
nautobot-docker-compose_nautobot-worker_1   nautobot-server rqworker         Up (unhealthy)                                                             
nautobot-docker-compose_nautobot_1          /docker-entrypoint.sh naut ...   Up (healthy)     0.0.0.0:8080->8080/tcp,:::8080->8080/tcp,                 
                                                                                              0.0.0.0:8443->8443/tcp,:::8443->8443/tcp                  
nautobot-docker-compose_redis_1             docker-entrypoint.sh sh -c ...   Up               6379/tcp                                                  
```


## Reference

* [nautobot-docker-compose](https://github.com/nautobot/nautobot-docker-compose)

