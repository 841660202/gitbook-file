<!--
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-01-09 12:54:31
 * @LastEditors  : hailong.chen
 * @LastEditTime : 2020-01-09 12:57:34
 * @Descripttion: 
 -->
# curl

将页面响应写入文件（-o）
使用 curl 将网页的响应消息写入到一个文件中，可以“-o”选项，如下：

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
上面的命令会将链接 http://mirrors.aliyun.com/repo/Centos-7.repo 的内容响应信息，写入到 /etc/yum.repos.d/CentOS-Base.repo 文件中。



本地测试

```
chenhailong@chenhailongdeMacBook-Pro:~/development$ mkdir curl
chenhailong@chenhailongdeMacBook-Pro:~/development$ cd curl/
chenhailong@chenhailongdeMacBook-Pro:~/development/curl$ ls
chenhailong@chenhailongdeMacBook-Pro:~/development/curl$ curl -o ./writeFile.html www.baidu.com
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2381  100  2381    0     0  45589      0 --:--:-- --:--:-- --:--:-- 46686
chenhailong@chenhailongdeMacBook-Pro:~/development/curl$ ls
writeFile.html
chenhailong@chenhailongdeMacBook-Pro:~/development/curl$ open -a chrome writeFile.html 
Unable to find application named 'chrome'
chenhailong@chenhailongdeMacBook-Pro:~/development/curl$ open -a "Google Chrome" writeFile.html 
chenhailong@chenhailongdeMacBook-Pro:~/development/curl$ 

```


包管理器

[Yum（全称为 Yellow dog Updater, Modified)](https://baike.baidu.com/item/yum/2835771?fr=aladdin)
