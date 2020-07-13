# 19.3 pod

##### 出发点

> 爱国、敬业

##### 安装失败

```
chenhailong@chenhailongdeMacBook-Pro:~/development/rn/AwesomeProject/ios$ pod install
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/universal-darwin19/rbconfig.rb:229: warning: Insecure world writable dir /usr/local/mysql/bin in PATH, mode 040777
Analyzing dependencies
Fetching podspec for `DoubleConversion` from `../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec`
Fetching podspec for `Folly` from `../node_modules/react-native/third-party-podspecs/Folly.podspec`
Fetching podspec for `glog` from `../node_modules/react-native/third-party-podspecs/glog.podspec`
Downloading dependencies
Installing CocoaAsyncSocket (7.6.4)
Installing CocoaLibEvent (1.0.0)
Installing DoubleConversion (1.1.6)
Installing FBLazyVector (0.62.2)
Installing FBReactNativeSpec (0.62.2)
Installing Flipper (0.33.1)
Installing Flipper-DoubleConversion (1.1.7)
Installing Flipper-Folly (2.2.0)
Installing Flipper-Glog (0.3.6)
Installing Flipper-PeerTalk (0.0.4)
Installing Flipper-RSocket (1.1.0)
Installing FlipperKit (0.33.1)
Installing Folly (2018.10.22.00)
Installing OpenSSL-Universal (1.0.2.19)

[!] Error installing OpenSSL-Universal
[!] /usr/local/bin/git clone https://github.com/krzyzanowskim/OpenSSL.git /var/folders/qk/bj_mbvq54zs663fjmkykq4cc0000gn/T/d20200623-52594-9hg3c2 --template= --single-branch --depth 1 --branch 1.0.2.19

Cloning into '/var/folders/qk/bj_mbvq54zs663fjmkykq4cc0000gn/T/d20200623-52594-9hg3c2'...
error: RPC failed; curl 56 LibreSSL SSL_read: SSL_ERROR_SYSCALL, errno 54
fatal: The remote end hung up unexpectedly
fatal: early EOF
fatal: index-pack failed
```

##### 处理方式

1. 梯子，并运行可以访问youtube.com

2. ```
   $ git config --global http.proxy socks5://127.0.0.1:1080
   $ git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
   取消配置
   git config --global --unset http.proxy
   git config --global --unset http.https://github.com.proxy
   
   ```

3. ```
   切换到项目iOS目录 pod install ，最终可完成安装
   ```

##### 结果

```
chenhailong@chenhailongdeMacBook-Pro:~/development/rn/AwesomeProject/ios$ pod install
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/universal-darwin19/rbconfig.rb:229: warning: Insecure world writable dir /usr/local/mysql/bin in PATH, mode 040777
Analyzing dependencies
Fetching podspec for `DoubleConversion` from `../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec`
Fetching podspec for `Folly` from `../node_modules/react-native/third-party-podspecs/Folly.podspec`
Fetching podspec for `glog` from `../node_modules/react-native/third-party-podspecs/glog.podspec`
Downloading dependencies
Installing CocoaAsyncSocket (7.6.4)
Installing CocoaLibEvent (1.0.0)
Installing DoubleConversion (1.1.6)
Installing FBLazyVector (0.62.2)
Installing FBReactNativeSpec (0.62.2)
Installing Flipper (0.33.1)
Installing Flipper-DoubleConversion (1.1.7)
Installing Flipper-Folly (2.2.0)
Installing Flipper-Glog (0.3.6)
Installing Flipper-PeerTalk (0.0.4)
Installing Flipper-RSocket (1.1.0)
Installing FlipperKit (0.33.1)
Installing Folly (2018.10.22.00)
Installing OpenSSL-Universal (1.0.2.19)
Installing RCTRequired (0.62.2)
Installing RCTTypeSafety (0.62.2)
Installing React (0.62.2)
Installing React-Core (0.62.2)
Installing React-CoreModules (0.62.2)
Installing React-RCTActionSheet (0.62.2)
Installing React-RCTAnimation (0.62.2)
Installing React-RCTBlob (0.62.2)
Installing React-RCTImage (0.62.2)
Installing React-RCTLinking (0.62.2)
Installing React-RCTNetwork (0.62.2)
Installing React-RCTSettings (0.62.2)
Installing React-RCTText (0.62.2)
Installing React-RCTVibration (0.62.2)
Installing React-cxxreact (0.62.2)
Installing React-jsi (0.62.2)
Installing React-jsiexecutor (0.62.2)
Installing React-jsinspector (0.62.2)
Installing ReactCommon (0.62.2)
Installing Yoga (1.14.0)
Installing YogaKit (1.18.1)
Installing boost-for-react-native (1.63.0)
Installing glog (0.3.5)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `AwesomeProject.xcworkspace` for this project from now on.
Pod installation complete! There are 47 dependencies from the Podfile and 37 total pods installed.
chenhailong@chenhailongdeMacBook-Pro:~/development/rn/AwesomeProject/ios$ pod install
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/universal-darwin19/rbconfig.rb:229: warning: Insecure world writable dir /usr/local/mysql/bin in PATH, mode 040777
Analyzing dependencies
Downloading dependencies
Generating Pods project
Integrating client project
Pod installation complete! There are 47 dependencies from the Podfile and 37 total pods installed.
chenhailong@chenhailongdeMacBook-Pro:~/development/rn/AwesomeProject/ios$ 

```

