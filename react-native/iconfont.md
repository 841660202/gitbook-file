# 19.4 iconfont

# React Native 与 Iconfont

[![img](https://upload.jianshu.io/users/upload_avatars/7061776/793bc1ec-ce25-40b9-b6e5-2f913a4db7ed?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp)](https://www.jianshu.com/u/7e5d5d65e048)

[我叫傻先生](https://www.jianshu.com/u/7e5d5d65e048)关注

2019.04.19 11:18:00字数 407阅读 580

*项目中因为不想使用小图标，打算使用`iconfont`,所以本文只要记录在`React Nativ`如何配置*

**React Native版本：0.57**

##### 一、下载

先去下载`IconFont`图标，将其中的`iconfont.css`和`iconfont.ttf`复制到你的项目中，我放入的目录是`appName/src/components/Icon`

##### 二、安装三方库

因为使用的typescript所以安装此版本
`yarn add @types/react-native-vector-icons`,

> 因为创建字体映射文件需要`generate-icon-set-from-css`,所以我也安装了普通版本`yarn add react-native-vector-icons`

##### 三、创建字体映射文件 `create-iconfont-json.js`

写入：



```jsx
const fs = require('fs');
const generateIconSetFromCss = require('react-native-vector-icons/lib/generate-icon-set-from-css');
// 和你刚才保存的iconfont字体文件在一起，方便管理
const cssDir = __dirname;
const iconSet = generateIconSetFromCss(cssDir + '/iconfont.css', 'icon-');

fs.writeFileSync(cssDir + '/iconfont.json', iconSet);
```

> 此文件主要用于创建字体映射文件，代码中的路径`__dirname`就是当前这个文件`create-iconfont-json.js`的路径，所以创建的`iconfont.css`也会生成在当前目录，创建完成后，文件格式大致为如下



```json
{
  "glass": 61440,
  "music": 61441,
  "search": 61442,
  "envelope-o": 61443,
  "heart": 61444,
  "star": 61445,
  "star-o": 61446,
  "user": 61447,
  //等等...
}
```

##### 四、创建脚本文件 `copy-font.sh`，

此文件作用是，运行`create-iconfont-json.js`文件，生成`iconfont.json`,同时把第一步保存的`iconfont.ttf`复制到`node_modules/react-native-vector-icons/Fonts/`目录



```bash
# 先生成json文件
node create-iconfont-json.js
# 当前文件路径
pwd
# 包自带的字体10几套，占空间，如果你需要那些字体库，把下面这行注释
rm -rf ../../../../node_modules/react-native-vector-icons/Fonts/*
# 复制iconfont字体文件至react-native-vector-icons/Fonts目录
cp -f ./iconfont.ttf ../../../../node_modules/react-native-vector-icons/Fonts/
# 链接到android和ios
cd ../../../../
react-native link react-native-vector-icons
```

> 文件中的`../../../../node_modules/react-native-vector-icons/Fonts/`路径，需要根据项目中此文件的位置来确定,运行`copy-font.sh`文件，`pwd`会输出当前路径，再确定路径

运行：
`sh copy-font.sh`

> windows下运行`sh`命令，如果有git，可以使用git bash，我使用的是[cmder](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.fixdown.com%2Fsoft%2F25628.html) 并注册到右键菜单

##### 五、创建`Iconfont`组件



```tsx
import React, { Component } from 'react'
import { createIconSet } from 'react-native-vector-icons'
const json = require('./iconfont.json')
const Icon: any = createIconSet(json, 'iconfont', 'iconfont.ttf')

export default class IconFont extends Component <any, any>{
  constructor (props: any) {
    super(props)
  }
  public state = {

  }
  render() {
    return (
        <Icon {...this.props}/>
    );
  }
}
```

> 为了方便管理，此文件在`AppName/src/components/Icon`中

##### 六、调用



```jsx
import IconFont from './components/Icon/IconFont'
<IconFont name="wangyiyunyinle" size = {20} color="#fff" />
```

[项目地址](https://links.jianshu.com/go?to=http%3A%2F%2Fhujiahua.site%3A8001%2Fhujiahua%2FwyApp)

