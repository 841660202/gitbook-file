# 19.2 brew

我用的是方法一

# homebrew代理设置

[![img](https://upload.jianshu.io/users/upload_avatars/332138/9820ded2-d4a9-42f5-925e-90d691412e84.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp)](https://www.jianshu.com/u/62f51c390c19)

[晓龙酱](https://www.jianshu.com/u/62f51c390c19)关注

0.3652017.11.13 22:31:51字数 109阅读 11,023

## 方法一

brew用curl下载，所以给curl挂上socks5的代理即可。

在~/.curlrc文件中输入代理地址即可。



```bash
socks5 = "127.0.0.1:1080"
```

## 方法二：替换源

替换为中科大源

- 替换brew.git：



```bash
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
```

- 替换homebrew-core.git:



```bash
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
```

- 替换Homebrew Bottles源：
  就是在/.bashrc或者/.zshrc文件末尾加



```cpp
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
```

这两个文件可以自己创建，/.bashrc和/.bash_profile都可以

## 重置源

- 重置brew.git



```bash
cd "$(brew --repo)"
git remote set-url origin https://github.com/Homebrew/brew.git
```

- 重置homebrew-core：



```bash
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://github.com/Homebrew/homebrew-core.git
```