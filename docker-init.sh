# 创建 docker bridge 网络
DOCKER_MOUNT_BASE_DIR="/c/dockerMount"

docker network create docker-bridge

# 创建 mysql (包含了adminer、soar-web工具)
export MYSQL_VERSION=5.7
export MYSQL_DATA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/mysql/data"
# mysql 8版本以上需要指定这个，如果非8版本，需要注释掉，还需要注释docker-compose.yml的改配置
export MYSQL_FILES_VOLUME="${DOCKER_MOUNT_BASE_DIR}/mysql/mysql-files"
export MYSQL_ADMINER_PORT=3380
cd mysql && docker-compose up -d && cd ..

# 创建 redis (包含了redisinsight工具),
export REDIS_VERSION=6.0.9
export REDIS_DATA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/redis/data"
cd redis && docker-compose up -d && cd ..

# 创建 elasticsearch (包含了kibana工具)，安装ik中文分词
export ES_VERSION=7.9.3
export ES_DATA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/elasticsearch/data"
export ES_PLUGINS_VOLUME="${DOCKER_MOUNT_BASE_DIR}/elasticsearch/plugins"
cd elasticsearch
# FIXME 先下载分词插件，复制到插件挂载目录下，github网络及慢，容易出问题，该步骤建议手工下载，解压并放置到$ES_PLUGINS_VOLUME目录下，然后注释以下两行代码即可
#curl "https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${ES_VERSION}/elasticsearch-analysis-ik-${ES_VERSION}.zip" -L -o ik.zip
#mkdir "${ES_PLUGINS_VOLUME}/ik/" && unzip -o ik.zip -d "${ES_PLUGINS_VOLUME}/ik/" && rm ik.zip
docker-compose up -d && cd ..

# 创建 fluentd
export FLUENTD_VERSION=v1.9.1-debian-1.0
export FLUENTD_LOG_VOLUME="${DOCKER_MOUNT_BASE_DIR}/fluentd/log"
export FLUENTD_CONF_VOLUME="${DOCKER_MOUNT_BASE_DIR}/fluentd/etc"
# FIXME 复制镜像的配置文件到 $FLUENTD_CONF_VOLUME 目录下，该步骤建议手工执行，并注释掉下一行语句，否则多次原因改脚本，会覆盖原先的配置
# docker run -it --rm --name fluentd_temp -v "${FLUENTD_CONF_VOLUME}:/fluentd/log/" "fluentd:${FLUENTD_VERSION}" bash -c "cp -r /fluentd/etc/* /fluentd/log&&exit"
cd fluentd && docker-compose up -d && cd ..

# 创建 influxdb
export INFLUXDB_VERSION=1.7.10
export INFLUXDB_DATA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/influxdb"
export INFLUXDB_DB=db0
export INFLUXDB_ADMIN_USER=admin
export INFLUXDB_ADMIN_PASSWORD=admin
export INFLUXDB_GRAPHITE_ENABLED=true
export INFLUXDB_USER=user
export INFLUXDB_USER_PASSWORD=user
cd influxdb && docker-compose up -d && cd ..

# 创建 jenkins
export JENKINS_VERSION=2.249.3-lts-centos7
export JENKINS_PORT=8888
# 整个 jenkins 挂载出来，方便修改
export JENKINS_HOME_VOLUME="${DOCKER_MOUNT_BASE_DIR}/jenkins/jenkins_home"
cd jenkins && docker-compose up -d && cd ..

# 创建 pulsar
export PULSAR_VERSION=2.5.2
export PULSAR_DATA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/pulsar/data"
export PULSAR_CONF_VOLUME="${DOCKER_MOUNT_BASE_DIR}/pulsar/conf"
export PULSAR_PORT=6650
export PULSAR_HTTP_PORT=8850
# FIXME 复制镜像的配置文件到 $FLUENTD_CONF_VOLUME 目录下，该步骤建议手工执行，并注释掉下一行语句，否则多次原因改脚本，会覆盖原先的配置
# docker run -it --rm --name pulsar_temp -v "${PULSAR_CONF_VOLUME}:/pulsar/data" "apachepulsar/pulsar:${PULSAR_VERSION}" bash -c "cp -r /pulsar/conf/* /pulsar/data&&exit"
cd pulsar && docker-compose up -d && cd ..

# 创建 openresty
export OPENRESTY_VERSION=1.15.8.3-centos
export OPENRESTY_NGINX_CONF_VOLUME="${DOCKER_MOUNT_BASE_DIR}/openresty/conf"
export OPENRESTY_LUA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/openresty/lua"
export OPENRESTY_NGINX_PORT=8088
#docker run -it --rm --name openresty_temp -v "${OPENRESTY_NGINX_CONF_VOLUME}:/etc/nginx/conf/" "openresty/openresty:${OPENRESTY_VERSION}" bash -c "cp -r /etc/nginx/conf.d/* /etc/nginx/conf/&&exit"
cd openresty && docker-compose up -d && cd ..

# 创建NFS SERVER
export NFS_SERVER_VERSION=2.4.3
export NFS_SERVER_SHARE_VOLUME="${DOCKER_MOUNT_BASE_DIR}/nfs-server/share"
export NFS_SERVER_PORT=2049
# mount命令 mount -v -t nfs -o vers=4,port=2049 nfs-server:/ /mount-path
cd nfs-server && docker-compose up -d && cd ..

# 创建httpbin
export HTTPBIN_PORT=8000
cd httpbin && docker-compose up -d && cd ..

# 创建allure
export ALLURE_DOCKER_SERVICE_PORT=5050
export ALLURE_DOCKER_WEB_PORT=5252
export ALLURE_DOCKER_SERVICE_PROJECTS_VOLUME="${DOCKER_MOUNT_BASE_DIR}/allure/projects"
cd allure && docker-compose up -d && cd ..

# 创建 ubuntu ssh
export UBUNTU_VERSION=20.04
export UBUNTU_SOURCES_VOLUME="${DOCKER_MOUNT_BASE_DIR}/ubuntu/sources.list"
export UBUNTU_DATA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/ubuntu/data"
cd ubuntu && docker-compose up -d && cd ..

# 创建 prometheus、grafana
export PROMETHEUS_DINGTAKL_CONFIG_FILE="${DOCKER_MOUNT_BASE_DIR}/prometheus/alertmanager/config.yml"
export PROMETHEUS_ALERMANAGER_CONFIG_FILE="${DOCKER_MOUNT_BASE_DIR}/prometheus/alertmanager/alertmanager.yml"
export PROMETHEUS_CONFIG_FILE="${DOCKER_MOUNT_BASE_DIR}/prometheus/prometheus/prometheus.yml"
export PROMETHEUS_ALERT_RULES_FILE="${DOCKER_MOUNT_BASE_DIR}/prometheus/prometheus/alert-rules.yml"
export PROMETHEUS_DATA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/prometheus/prometheus/data"
export PROMETHEUS_GRAFANA_VOLUME="${DOCKER_MOUNT_BASE_DIR}/prometheus/grafana"
cd prometheus && docker-compose up -d && cd ..

# 创建gitlab, 在windows下gitlab-data需要用volume方式，直接bind或报错：Error executing action `create` on resource 'storage_directory[/var/opt/gitlab/.ssh]'
docker volume create gitlab-data
docker volume create gitlab-log
export GITLAB_HOME="${DOCKER_MOUNT_BASE_DIR}/gitlab"
cd gitlab && docker-compose up -d && cd ..