# 创建 docker bridge 网络
docker network create docker-bridge

# 创建 mysql (包含了adminer、soar-web工具)
export MYSQL_VERSION=8.0.22
export MYSQL_DATA_VOLUME=c:/dockerMount/mysql/data
# mysql 8版本以上需要指定这个，如果非8版本，需要注释掉，还需要注释docker-compose.yml的改配置
export MYSQL_FILES_VOLUME=c:/dockerMount/mysql/mysql-files
cd mysql && docker-compose up -d && cd ..

# 创建 redis (包含了redisinsight工具),
export REDIS_VERSION=6.0.9
export REDIS_DATA_VOLUME=c:/dockerMount/redis/data
cd redis && docker-compose up -d && cd ..

# 创建 elasticsearch (包含了kibana工具)
export ES_VERSION=7.9.3
export ES_DATA_VOLUME=c:/dockerMount/elasticsearch/data
export ES_PLUGINS_VOLUME=c:/dockerMount/elasticsearch/plugins
cd elasticsearch
# 先下载分词插件，复制到插件挂载目录下，github网络及慢，容易出问题，该步骤建议手工下载，解压并放置到$ES_PLUGINS_VOLUME目录下，然后注释以下两行代码即可
#curl "https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${ES_VERSION}/elasticsearch-analysis-ik-${ES_VERSION}.zip" -L -o ik.zip
#mkdir "${ES_PLUGINS_VOLUME}/ik/" && unzip -o ik.zip -d "${ES_PLUGINS_VOLUME}/ik/" && rm ik.zip
docker-compose up -d && cd ..

# 创建 fluentd
export FLUENTD_VERSION=v1.9.1-debian-1.0
export FLUENTD_LOG_VOLUME=c:/dockerMount/fluentd/log
export FLUENTD_CONF_VOLUME=c:/dockerMount/fluentd/etc
# 复制镜像的配置文件到 $FLUENTD_CONF_VOLUME 目录下，该步骤建议手工执行，并注释掉下一行语句，否则多次原因改脚本，会覆盖原先的配置
docker run -it --rm --name fluentd_temp -v "${FLUENTD_CONF_VOLUME}:/fluentd/log/" "fluentd:${FLUENTD_VERSION}" bash -c "cp -r /fluentd/etc/* /fluentd/log&&exit"
cd fluentd && docker-compose up -d && cd ..

