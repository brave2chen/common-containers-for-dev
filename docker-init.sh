# 创建 docker bridge 网络
docker network create docker-bridge

# 创建 redis (包含了redisinsight工具),
export REDIS_TAG=6.0.9
export REDIS_DATA_VOLUME=/c/dockerMount/redis/data
cd redis && docker-compose up -d

# 创建 elasticsearch (包含了kibana工具)