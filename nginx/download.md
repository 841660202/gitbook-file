# 11.1 gulp


- 旧配置nginx
  
```
编辑配置
vi /app/nginx/conf.d/gogs.conf
/app/nginx/www
刷新配置

```

```
docker exec -it nginx /etc/init.d/nginx reload
docker restart nginx
```


```

proxy_buffer_size 128k;
   proxy_buffers   32 128k;
   proxy_busy_buffers_size 128k;
   server {
        listen 80;
        server_name demo-h5.aijs.club;    # 把域名替换成你自己的
        location / {
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:5557;      # 这里设置你要代理的ip+端口
          }
    }
    server {
      listen 80;
        server_name tn.aijs.club;    # 把域名替换成你自己的
        location / {
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:3000;      # 这里设置你要代理的ip+端
          }
    }
    server {
        listen 80;
        server_name re.aijs.club;    # 把域名替换成你自己的
         location / {
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:3000;      # 这里设置你要代理的ip+端
          }
    }
    server {
        listen 80;
        server_name redirect.aijs.club;    # 把域名替换成你自己的
        location / {
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:3000;      # 这里设置你要代理的ip+端
          }
    }
    server {
        listen 80;
        server_name demo-test.aijs.club;    # 把域名替换成你自己的
        location / {
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:5556;      # 这里设置你要代理的ip+端口
          }
    } 
   server {
        listen 80;
        server_name shop-test.aijs.club;    # 把域名替换成你自己的
        location / {
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:5555;      # 这里设置你要代理的ip+端口
          }
    }

    server {
        listen 80;
        server_name wx.aijs.club;    # 把域名替换成你自己的
        location / {
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:8080;      # 这里设置你要代理的ip+端口
          }
    }

    server {
        listen 80;
        server_name emr-after.aijs.club;    # 把域名替换成你自己的
        location / {
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:5558;    # 这里设置你要代理的ip+端口
          }
        location /api {
             proxy_pass http://hailong.vaiwan.com;   # 代理到自己电脑
          }
    }

    server {
        listen 80;
        server_name blogProxy.aijs.club;    # 把域名替换成你自己的
        location / {
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:9999;    # 这里设置你要代理的ip+端口
          }
        location /api {
            proxy_pass https://devgateway.92jiangbei.com;
             # proxy_pass http://ant-design-pro.netlify.com;
             # proxy_pass https://devgateway.92jiangbei.com;    # 这里设置你要代理的ip+端口
          }
        location /bc-verify-recharge {
             proxy_pass https://devgateway.92jiangbei.com;
             # proxy_pass http://ant-design-pro.netlify.com;
             # proxy_pass https://devgateway.92jiangbei.com;    # 这里设置你要代理的ip+端口
          }
    }
           
    server {
        listen 80;
        server_name jenkins.aijs.club;    # 把域名替换成你自己的
        location / {
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:8080/jenkins/;
          }
    }
    server {
        listen 80;
        server_name hub.aijs.club;    # 把域名替换成你自己的
        location / {
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:5000;      # 这里设置你要代理的ip+端口
          }
    }
    server {
        listen 80;
        server_name download.aijs.club;    # 把域名替换成你自己的
        location / {
        default_type application/octet-stream;
        proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://172.16.232.68:5559;      # 这里设置你要代理的ip+端口
          }
    }
    server {
    listen 80;
    server_name blog.aijs.club;    # 把域名替换成你自己的
    location / {
     proxy_redirect off;  
        proxy_set_header Host $host;  
        proxy_set_header X-Real-IP $remote_addr;  
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
        proxy_pass http://172.16.232.68:6666;      # 这里设置你要代理的ip+端口
      }
   }
   server {
         listen 80;
         server_name apk.aijs.club;    # 把域名替换成你自己的
         location / {
                proxy_redirect off;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_pass http://172.16.232.68:6667;      # 这里设置你要代理的ip+端口
      }
   }
```

新配置nginx

```
# 编辑配置
vi /etc/nginx/nginx.conf
/app/nginx/www
# 刷新配置
docker exec -it nginx /etc/init.d/nginx reload
docker restart nginx
```

拷贝
```
scp -r /Users/chenhailong/development/electron/my-project/build/my-project-0.0.1.dmg root@47.99.211.128:/app/download/nginx/www
```

启动下载容器
```
docker run --name=download -p 5559:80  -v /app/download/nginx/www:/usr/share/nginx/html  -d --restart=always  nginx 

```

拷贝资源到容齐/或者放到映射卷中
```
docker cp . download://usr/share/nginx/html

```

位置：
```
/app/download/nginx/www
```

资源拷贝
```
scp -r /Users/chenhailong/development/electron/my-project/build/my-project-0.0.1.dmg root@47.99.211.128:/app/download/nginx/www
```
备份之前配置
```
server {
  listen 80;
  server_name download.aijs.club;    # 把域名替换成你自己的
  location / {
      proxy_redirect off;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_pass http://172.16.232.68:8096;      # 这里设置你要代理的ip+端口
    }
  location /download {
    add_header   Content-Type     "application/octet-stream;charset=utf-8";
    add_header   Content-Disposition "attachment; filename*=utf-8'zh_cn'$arg_n";
    proxy_pass http://172.16.232.68:5559;      # 这里设置你要代理的ip+端口
  }

}

```
- 下载地址测试
  
[http://download.aijs.club/download/my-project-0.0.1.dmg](http://download.aijs.club/download/my-project-0.0.1.dmg)