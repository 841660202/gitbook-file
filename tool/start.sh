###
 # @version: v0.0.1
 # @Author: hailong.chen
 # @Date: 2020-01-05 15:23:07
 # @LastEditors  : hailong.chen
 # @LastEditTime : 2020-01-05 15:29:37
 # @Descripttion: 
 ###
# docker run \
# --detach \
# --publish 11443:443 \    # 映射https端口, 不过本文中没有用到
# --publish 11080:80 \      # 映射宿主机8090端口到容器中80端口
# --publish 11022:22 \      # 映射22端口, 可不配
# --name gitlab \            
# --restart always \
# --hostname gitlba.aijs.club \    # 局域网宿主机的ip, 如果是公网主机可以写域名
# -v /Users/chenhailong/gitlab/srv/gitlab/config:/etc/gitlab \    # 挂载gitlab的配置文件
# -v /Users/chenhailong/gitlab/srv/gitlab/logs:/var/log/gitlab \    # 挂载gitlab的日志文件
# -v /Users/chenhailong/gitlab/srv/gitlab/data:/var/opt/gitlab \    # 挂载gitlab的数据
# -v /etc/localtime:/etc/localtime:ro \    # 保持宿主机和容器时间同步
# --privileged=true gitlab/gitlab-ce    # 在容器中能以root身份执行操作



sudo docker run --detach \
	--hostname gitlab.example.com \
	--env GITLAB_OMNIBUS_CONFIG="external_url 'http://gitlab.aijs.club'; gitlab_rails['lfs_enabled'] = true;" \
	--publish 10443:443 --publish 10080:80 --publish 10022:22 \
	--name gitlab \
	--restart always \
	--volume /Users/chenhailong/gitlab/srv/gitlab/config:/etc/gitlab \
	--volume /Users/chenhailong/gitlab/srv/gitlab/logs:/var/log/gitlab \
	--volume /Users/chenhailong/gitlab/srv/gitlab/data:/var/opt/gitlab \
	gitlab/gitlab-ce:latest