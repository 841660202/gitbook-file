# 简介

[预览](http://am-file.aijs.club/)


本文简单介绍如何安装并使用gitbook，最后如何使用docker构建书籍镜像。

1. 前置条件
需要Nodejs环境，安装npm，国内用户再安装cnpm

```
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

2. 安装gitbook
  
```
cnpm install -g gitbook-cli
gitbook -V 
CLI version: 2.3.2
Installing GitBook 3.2.3
gitbook@3.2.3 ..\AppData\Local\Temp\tmp-20544doJtj1hfVp40\node_modules\gitbook
├── escape-string-regexp@1.0.5
├── escape-html@1.0.3
 。。。。
GitBook version: 3.2.3
```

1. gitbook使用
3.1 生成目录和图书结构

```
mkdir docker-start
gitbook init
warn: no summary file in this book
info: create README.md
info: create SUMMARY.md
info: initialization is finished
```

编辑SUMMARY.md，输入：

```
* [简介](README.md)
* [1.Docker入门](chapter1/README.md)
 - [1.1 什么是Docker](chapter1/section1.md)
 - [1.2 Docker基本概念](chapter1/section2.md)
 - [1.3 安装Docker](chapter1/section3.md)
 - [1.4 使用Docker镜像](chapter1/section4.md)
 - [1.5 操作容器](chapter1/section5.md)
 - [1.6 访问仓库](chapter1/section6.md)
 - [1.6 数据管理](chapter1/section7.md)
* [2.使用Docker部署web应用](chapter2/README.md)
 - [2.1 编写DockerFile](chapter2/section1.md)
 - [2.2 编写web应用](chapter2/section2.md)
 - [2.3 构建镜像](chapter2/section3.md)
 - [2.4 运行web应用](chapter2/section4.md)
 - [2.5 分享镜像](chapter2/section5.md)
* [结束](end/README.md)
```

再次执行：

```
gitbook init
info: create chapter1/README.md
info: create chapter1/section1.md
info: create chapter1/section2.md
info: create chapter1/section3.md
info: create chapter1/section4.md
info: create chapter1/section5.md
info: create chapter1/section6.md
info: create chapter1/section7.md
info: create chapter2/README.md
info: create chapter2/section1.md
info: create chapter2/section2.md
info: create chapter2/section3.md
info: create chapter2/section4.md
info: create chapter2/section5.md
info: create end/README.md
info: create SUMMARY.md
info: initialization is finished
```
3.2 生成图书
使用：

```
gitbook serve .
Live reload server started on port: 35729
Press CTRL+C to quit ...

info: 7 plugins are installed
info: loading plugin "livereload"... OK
info: loading plugin "highlight"... OK
info: loading plugin "search"... OK
info: loading plugin "lunr"... OK
info: loading plugin "sharing"... OK
info: loading plugin "fontsettings"... OK
info: loading plugin "theme-default"... OK
info: found 16 pages
info: found 15 asset files
info: >> generation finished with success in 4.0s !

Starting server ...
Serving book on http://localhost:4000
访问 http://localhost:4000 ，就可以看到图书了
```



编辑生成的md，gitbook会自动Restart，



在当前目录下，会生成一个_book目录 ，里面是生成的静态html，可以发布到服务器直接使用。

1. 使用docker发布gitbook书籍
首先 将_book目录里的内容拷贝到一个新目录。

然后编写Dockerfile

```
FROM nginx
WORKDIR /usr/share/nginx/html
ADD . /usr/share/nginx/html
EXPOSE 80
```

```
build：

docker build -t docker-start-web .
Sending build context to Docker daemon  4.766MB
Step 1/4 : FROM nginx
 ---> 3f8a4339aadd
Step 2/4 : WORKDIR /usr/share/nginx/html
Removing intermediate container a4232f4b6b62
 ---> 91a66299ecad
Step 3/4 : ADD . /usr/share/nginx/html
 ---> 9a9fef80da3b
Step 4/4 : EXPOSE 80
 ---> Running in 59f2b829aba6
Removing intermediate container 59f2b829aba6
 ---> b92c92688046
Successfully built b92c92688046
Successfully tagged docker-start-web:latest
```

执行：

```
docker run -p 4000:80 --name docker-start-web -d docker-start-web
f91cf4446b3746c665476b3dd214446a941d838fa9a3ad47680190bb08c9aa48
访问服务器ip:4000就可以查看到了。
```

创建级联目录
mkdir -p _layouts/website/

```
linux 创建多级目录 mkdir -p
原文地址：http://www.dutor.net/index.php/2010/06/cmd-mkdir-p/
mkdir的-p选项允许你一次性创建多层次的目录，而不是一次只创建单独的目录。例如，我们要在当前目录创建目录Projects/a/src，使用命令

mkdir -p Project/a/src
而不是

mkdir Project
cd Project
mkdir a
cd a
mkdir src
　　当然，如果你有mkcd，就可以直接

mkcd Project/a/src
　　此外，如果我们想创建多层次、多维度的目录树，mkcd也显得比较苍白了。例如我们想要建立目录Project，其中含有4个文件夹a, b, c, d，且这4个文件都含有一个src文件夹。或许，我们可以逐个创建，但我更倾向于使用单个命令来搞定，而mkdir 的-p选项和shell的参数扩展允许我这么做，例如下面的一个命令就可以完成任务。

1
mkdir -p Project/{a,b,c,d}/src
　　嗯，mkdir -p到此over~
```


改写Published with GitBook

部署到服务器

[手动方式](https://blog.csdn.net/fwhezfwhez/article/details/86756036)

docker方式
```
docker build -t gitbook-file .
docker run -p 2000:80 --name gitbook-file  -d gitbook-file 
```


```
server {
      listen 80;
      server_name am-file.aijs.club;    # 把域名替换成你自己的
      location / {
      proxy_redirect off;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_pass http://172.16.232.68:2000;    
        }
  }
```


- [参考](https://www.cnblogs.com/xiaoqi/p/8194350.html)
- [改写](https://www.jianshu.com/p/9c706dfa2d4e)
- [定制](https://blog.csdn.net/qq_43514847/article/details/86598399)
- [起源](http://book.5kcrm.com/)



```
scp -r /Users/chenhailong/mygithub/文档/gitbook-file/_book root@47.99.211.128:/root/文档/

```
### 运行结果
```
Last login: Mon Jul 13 10:34:07 on ttys009
N/A: version "N/A -> N/A" is not yet installed.

You need to run "nvm install N/A" to install it before using it.
N/A: version "N/A -> N/A" is not yet installed.

You need to run "nvm install N/A" to install it before using it.

The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
chenhailong@chenhailongdeMacBook-Pro:~$ scp -r /Users/chenhailong/mygithub/文档/gitbook-file/_book root@47.99.211.128:/root/文档/
index.html                                    100%   44KB 251.9KB/s   00:00    
index.html                                    100%   35KB   1.3MB/s   00:00    
image-20200622170807067.png                   100% 2332KB   1.1MB/s   00:02    
image-20200622170348394.png                   100% 2770KB   1.0MB/s   00:02    
simulator.html                                100%   36KB   1.5MB/s   00:00    
dpr.html                                      100%   38KB   3.0MB/s   00:00    
install.html                                  100%   43KB   1.6MB/s   00:00    
index.html                                    100%   35KB   2.5MB/s   00:00    
h5.html                                       100%   59KB   1.6MB/s   00:00    
brew.html                                     100%   38KB   1.8MB/s   00:00    
pod.html                                      100%   40KB   2.2MB/s   00:00    
iconfont.html                                 100%   43KB   1.8MB/s   00:00    
1.jpeg                                        100%  272KB   4.1MB/s   00:00    
6.jpeg                                        100%  158KB 418.7KB/s   00:00    
4.jpeg                                        100%  217KB   3.0MB/s   00:00    
5.jpeg                                        100%  149KB   3.5MB/s   00:00    
2.jpeg                                        100%  148KB   2.8MB/s   00:00    
7.png                                         100% 3210KB 833.6KB/s   00:03    
3.jpeg                                        100%   90KB   1.7MB/s   00:00    
logo.jpeg                                     100%   18KB   1.7MB/s   00:00    
code-msg.png                                  100%  239KB   3.0MB/s   00:00    
section7.html                                 100%   35KB   1.5MB/s   00:00    
index.html                                    100%   35KB   1.7MB/s   00:00    
section6.html                                 100%   35KB   1.7MB/s   00:00    
section1.html                                 100%   36KB   2.8MB/s   00:00    
section3.html                                 100%   35KB   2.1MB/s   00:00    
section2.html                                 100%   35KB   2.5MB/s   00:00    
section5.html                                 100%   35KB   1.8MB/s   00:00    
section4.html                                 100%   35KB   2.0MB/s   00:00    
Dockerfile                                    100%  161    16.8KB/s   00:00    
index.html                                    100%   40KB   1.9MB/s   00:00    
index.html                                    100%   36KB   2.6MB/s   00:00    
taro-cache.html                               100%   41KB   2.0MB/s   00:00    
index.html                                    100%   35KB   1.8MB/s   00:00    
8.png                                         100%  231KB   3.9MB/s   00:00    
9.png                                         100%  400KB 498.9KB/s   00:00    
10.png                                        100%  205KB   2.5MB/s   00:00    
10.1.png                                      100%  318KB   3.9MB/s   00:00    
4.png                                                                                                                  100%  419KB 604.2KB/s   00:00    
5.png                                                                                                                  100%  329KB 582.2KB/s   00:00    
7.png                                                                                                                  100%  259KB   2.3MB/s   00:00    
6.png                                                                                                                  100%  236KB   3.8MB/s   00:00    
2.png                                                                                                                  100%  195KB 294.3KB/s   00:00    
3.png                                                                                                                  100%  100KB   1.9MB/s   00:00    
1.png                                                                                                                  100%  197KB   2.8MB/s   00:00    
9.1.png                                                                                                                100%  331KB 379.9KB/s   00:00    
mini-app.html                                                                                                          100%   35KB 696.3KB/s   00:00    
gzh.html                                                                                                               100%   42KB   1.0MB/s   00:00    
taro.html                                                                                                              100%   64KB   1.5MB/s   00:00    
search_index.json                                                                                                      100% 1851KB 796.2KB/s   00:02    
index.html                                                                                                             100%   36KB 588.5KB/s   00:00    
index.html                                                                                                             100%   37KB 459.9KB/s   00:00    
index.html                                                                                                             100%   35KB   1.7MB/s   00:00    
1577519185.png                                                                                                         100%   14KB 709.5KB/s   00:00    
1577521788.png                                                                                                         100%   12KB 623.7KB/s   00:00    
clean-cache.html                                                                                                       100%   35KB   1.8MB/s   00:00    
index.html                                                                                                             100%   35KB   1.4MB/s   00:00    
start.html                                                                                                             100%   58KB   1.9MB/s   00:00    
mock.html                                                                                                              100%   35KB   1.7MB/s   00:00    
.gitignore                                                                                                             100%  489    31.4KB/s   00:00    
index.html                                                                                                             100%  114KB   2.6MB/s   00:00    
161436867.png                                                                                                          100%   34KB   1.5MB/s   00:00    
download.html                                                                                                          100%   46KB   1.7MB/s   00:00    
index.html                                                                                                             100%   35KB 402.5KB/s   00:00    
mysqld-fix.png                                                                                                         100%  928KB   1.4MB/s   00:00    
mysql-run-well.png                                                                                                     100%  148KB   1.6MB/s   00:00    
mysqld.png                                                                                                             100% 1297KB 601.3KB/s   00:02    
mac-mysql-warning.png                                                                                                  100%   18KB   1.5MB/s   00:00    
config.html                                                                                                            100%   35KB   3.2MB/s   00:00    
index.html                                                                                                             100%   35KB   2.0MB/s   00:00    
fe-single-spa.html                                                                                                     100%   35KB   1.9MB/s   00:00    
fe-qiankun.html                                                                                                        100%   70KB   2.1MB/s   00:00    
fe-icestark.html                                                                                                       100%   38KB   3.8MB/s   00:00    
README.md                                                                                                              100% 7621   676.5KB/s   00:00    
index.html                                                                                                             100%   35KB   2.5MB/s   00:00    
umi-request.html                                                                                                       100%   65KB   3.4MB/s   00:00    
fetch.html                                                                                                             100%   35KB   1.7MB/s   00:00    
js.html                                                                                                                100%   39KB   1.8MB/s   00:00    
axios.html                                                                                                             100%   35KB   1.7MB/s   00:00    
index.html                                                                                                             100%   35KB   1.7MB/s   00:00    
section1.html                                                                                                          100%   35KB   1.7MB/s   00:00    
section3.html                                                                                                          100%   35KB   1.3MB/s   00:00    
section2.html                                                                                                          100%   35KB   2.8MB/s   00:00    
section5.html                                                                                                          100%   35KB   1.8MB/s   00:00    
section4.html                                                                                                          100%   35KB   3.1MB/s   00:00    
index.html                                                                                                             100%   35KB   2.3MB/s   00:00    
curl.html                                                                                                              100%   37KB   2.9MB/s   00:00    
index.html                                                                                                             100%   37KB   1.7MB/s   00:00    
plugin.js.map                                                                                                          100% 3690   145.1KB/s   00:00    
style.css                                                                                                              100% 1880   193.4KB/s   00:00    
plugin.js                                                                                                              100% 1609    76.2KB/s   00:00    
favicon.ico                                                                                                            100% 4286   414.5KB/s   00:00    
apple-touch-icon-precomposed-152.png                                                                                   100% 4817   413.4KB/s   00:00    
expandable-chapters-small.css                                                                                          100%  580    47.8KB/s   00:00    
expandable-chapters-small.js                                                                                           100% 2058   195.9KB/s   00:00    
plugin.js                                                                                                              100%  327    13.0KB/s   00:00    
website.css                                                                                                            100%   31KB   2.6MB/s   00:00    
ebook.css                                                                                                              100% 2865   264.6KB/s   00:00    
footer.css                                                                                                             100% 3786   277.3KB/s   00:00    
plugin.css                                                                                                             100%  138    11.0KB/s   00:00    
plugin.js                                                                                                              100% 2603   266.3KB/s   00:00    
search-engine.js                                                                                                       100% 1268   117.4KB/s   00:00    
search.css                                                                                                             100%  974    70.7KB/s   00:00    
search.js                                                                                                              100% 6368   356.4KB/s   00:00    
lunr.min.js                                                                                                            100%   15KB 844.2KB/s   00:00    
theme.js                                                                                                               100%  111KB   2.8MB/s   00:00    
plugin.js                                                                                                              100%  388    18.4KB/s   00:00    
plugin.css                                                                                                             100%  209    16.4KB/s   00:00    
gitbook.js                                                                                                             100%  103KB   2.5MB/s   00:00    
toggle.js                                                                                                              100% 3013   184.1KB/s   00:00    
style.css                                                                                                              100%   51KB   2.3MB/s   00:00    
search-lunr.js                                                                                                         100% 1616    70.0KB/s   00:00    
lunr.min.js                                                                                                            100%   15KB   1.4MB/s   00:00    
plugin.css                                                                                                             100% 2267    88.8KB/s   00:00    
plugin.js                                                                                                              100% 3093   148.9KB/s   00:00    
plugin.css                                                                                                             100% 1213    33.7KB/s   00:00    
plugin.js                                                                                                              100%  584    19.2KB/s   00:00    
fontawesome-webfont.svg                                                                                                100%  382KB   3.6MB/s   00:00    
FontAwesome.otf                                                                                                        100%  122KB 832.6KB/s   00:00    
fontawesome-webfont.woff2                                                                                              100%   70KB   1.0MB/s   00:00    
fontawesome-webfont.ttf                                                                                                100%  149KB   2.5MB/s   00:00    
fontawesome-webfont.woff                                                                                               100%   88KB   2.7MB/s   00:00    
fontawesome-webfont.eot                                                                                                100%   75KB   4.8MB/s   00:00    
splitter.js                                                                                                            100% 3864   206.9KB/s   00:00    
splitter.css                                                                                                           100%  503    30.0KB/s   00:00    
fontsettings.js                                                                                                        100% 6447   424.6KB/s   00:00    
website.css                                                                                                            100% 8596   845.5KB/s   00:00    
lightbox.min.css                                                                                                       100% 2532   210.9KB/s   00:00    
loading.gif                                                                                                            100% 8476   664.1KB/s   00:00    
next.png                                                                                                               100% 1350    69.1KB/s   00:00    
prev.png                                                                                                               100% 1360   145.7KB/s   00:00    
close.png                                                                                                              100%  280    28.5KB/s   00:00    
jquery.slim.min.js                                                                                                     100%   69KB   3.2MB/s   00:00    
lightbox.min.js                                                                                                        100% 9512   625.1KB/s   00:00    
buttons.js                                                                                                             100% 2875   222.4KB/s   00:00    
excelMergeCell2Data.html                                                                                               100%   57KB   2.6MB/s   00:00    
index.html                                                                                                             100%   35KB   2.1MB/s   00:00    
WX20200104-230614@2x.png                                                                                               100%  550KB 539.4KB/s   00:01    
WX20200105-000810@2x.png                                                                                               100% 1009KB 780.8KB/s   00:01    
6.gif                                                                                                                  100%   13MB 840.6KB/s   00:15    
/Users/chenhailong/mygithub/文档/gitbook-file/_book/node/npmRunPublish.html: No such file or directory
/Users/chenhailong/mygithub/文档/gitbook-file/_book/node/koa2-token-redis.html: No such file or directory
/Users/chenhailong/mygithub/文档/gitbook-file/_book/node/docker-node.html: No such file or directory
/Users/chenhailong/mygithub/文档/gitbook-file/_book/node/code2markdown.html: No such file or directory
/Users/chenhailong/mygithub/文档/gitbook-file/_book/electron: No such file or directory
1.jpg                                                                                                                  100%   85KB 597.5KB/s   00:00    
/Users/chenhailong/mygithub/文档/gitbook-file/_book/git: No such file or directory
image-20200603130337477.png                                                                                            100%   52KB   1.2MB/s   00:00    
image-20200602155955972.png                                                                                            100%   68KB   1.3MB/s   00:00    
gitlab-域名4.png                                                                                                                                    100% 2185KB 824.5KB/s   00:02    
gitlab-issue.png                                                                                                                                      100%  250KB   2.7MB/s   00:00    
shell-find-rm.gif                                                                                                                                     100% 2732KB 630.9KB/s   00:04    
gitlab-域名3.png                                                                                                                                    100% 1463KB 676.7KB/s   00:02    
gitlab-域名2.png                                                                                                                                    100%  297KB   2.0MB/s   00:00    
gitlab-preference.png                                                                                                                                 100%  436KB 427.8KB/s   00:01    
gitlab-域名1.png                                                                                                                                    100% 2168KB 855.8KB/s   00:02    
image-20200603130424287.png                                                                                                                           100%  646KB 779.1KB/s   00:00    
gitlab-email.png                                                                                                                                      100%  303KB 346.7KB/s   00:00    
image-20200603125300635.png                                                                                                                           100%  621KB   1.0MB/s   00:00    
image-20200602091525795.png                                                                                                                           100%   87KB   1.1MB/s   00:00    
gitlab-ssh.png                                                                                                                                        100%  319KB   1.2MB/s   00:00    
gitlab-域名5重启.png                                                                                                                              100% 2715KB 771.0KB/s   00:03    
image-20200603125025233.png                                                                                                                           100%   85KB   2.3MB/s   00:00    
image-20200602091652587.png                                                                                                                           100%  305KB 538.6KB/s   00:00    
shell-sed.png                                                                                                                                         100%  646KB 894.6KB/s   00:00    
gitlab-域名6-推送代码.png                                                                                                                       100%  811KB   1.2MB/s   00:00    
gitlab-合并请求.png                                                                                                                               100%  192KB   2.9MB/s   00:00    
gitlab-域名6-重新运行命令.png                                                                                                                 100% 1282KB 1000.0KB/s   00:01   
gitlab-域名7-推送成功结果查看.png                                                                                                           100%  359KB 595.7KB/s   00:00    
chrome_run_other_js.gif                                                                                                                               100%  558KB 924.4KB/s   00:00    
image-20200602091812409.png                                                                                                                           100%   96KB   1.5MB/s   00:00    
gitlab-设置中文.png                                                                                                                               100%  341KB   3.8MB/s   00:00    
gitlab-todo.png                                                                                                                                       100%  224KB 296.3KB/s   00:00    
gulp-Browsersync.png                                                                                                                                  100%  123KB 736.1KB/s   00:00    
shell-命令行变量.png                                                                                                                             100%  239KB 920.7KB/s   00:00    
inspect.out.md                                                                                                                                        100%   33KB 820.8KB/s   00:00    
start.sh                                                                                                                                              100% 1513    28.1KB/s   00:00 

```

