# 3. taro
## 项目结构
```
.
├── README.md
├── config
│   ├── dev.js
│   ├── index.js
│   └── prod.js
├── global.d.ts
├── p.text
├── package.json
├── project.config.json
├── schema.json
├── src
│   ├── app.scss
│   ├── app.tsx
│   ├── assets
│   │   ├── home_0.png
│   │   ├── home_1.png
│   │   ├── mine_0.png
│   │   ├── mine_1.png
│   │   ├── msg_0.png
│   │   └── msg_1.png
│   ├── commonType.ts
│   ├── components
│   │   ├── button
│   │   │   ├── bottom.tsx
│   │   │   └── index.scss
│   │   ├── formItem
│   │   │   ├── index.scss
│   │   │   └── index.tsx
│   │   ├── loading
│   │   │   └── loadingMore.tsx
│   │   ├── navItme
│   │   │   ├── index.scss
│   │   │   └── index.tsx
│   │   ├── nothing
│   │   │   ├── index.scss
│   │   │   └── index.tsx
│   │   ├── radio
│   │   │   ├── index.scss
│   │   │   └── index.tsx
│   │   └── topTab
│   │       ├── index.scss
│   │       └── index.tsx
│   ├── consts.ts
│   ├── hooks
│   │   └── userInfo.ts
│   ├── http
│   │   ├── config.ts
│   │   ├── index.ts
│   │   └── message.ts
│   ├── index.html
│   ├── pages
│   │   ├── application
│   │   │   ├── medical
│   │   │   │   ├── detail
│   │   │   │   │   ├── index.tsx
│   │   │   │   │   └── service.ts
│   │   │   │   ├── form
│   │   │   │   │   ├── index.tsx
│   │   │   │   │   └── service.ts
│   │   │   │   ├── hosp
│   │   │   │   │   ├── index.tsx
│   │   │   │   │   └── service.ts
│   │   │   │   ├── package
│   │   │   │   │   ├── index.tsx
│   │   │   │   │   └── service.ts
│   │   │   │   ├── products
│   │   │   │   │   ├── index.tsx
│   │   │   │   │   └── service.ts
│   │   │   │   └── transporters
│   │   │   │       ├── index.tsx
│   │   │   │       └── service.ts
│   │   │   └── mine
│   │   │       ├── detail
│   │   │       │   └── index.tsx
│   │   │       ├── list
│   │   │       │   ├── index.tsx
│   │   │       │   └── service.ts
│   │   │       ├── products
│   │   │       │   └── index.tsx
│   │   │       ├── remark
│   │   │       │   ├── index.tsx
│   │   │       │   └── service.ts
│   │   │       └── resume
│   │   │           ├── index.tsx
│   │   │           └── service.ts
│   │   ├── backWH
│   │   │   ├── detail
│   │   │   │   ├── index.tsx
│   │   │   │   └── service.ts
│   │   │   ├── form
│   │   │   │   ├── index.tsx
│   │   │   │   └── service.ts
│   │   │   ├── inputCode
│   │   │   │   └── index.tsx
│   │   │   ├── list
│   │   │   │   ├── index.tsx
│   │   │   │   └── service.ts
│   │   │   ├── products
│   │   │   │   ├── index.tsx
│   │   │   │   └── service.ts
│   │   │   ├── snapshot
│   │   │   │   ├── index.tsx
│   │   │   │   └── service.ts
│   │   │   └── submit
│   │   │       ├── index.tsx
│   │   │       └── service.ts
│   │   ├── clock
│   │   │   ├── back
│   │   │   │   └── list
│   │   │   │       ├── index.tsx
│   │   │   │       └── service.ts
│   │   │   ├── common
│   │   │   │   ├── detail
│   │   │   │   │   ├── index.tsx
│   │   │   │   │   └── service.ts
│   │   │   │   ├── products
│   │   │   │   │   └── index.tsx
│   │   │   │   └── resume
│   │   │   │       ├── index.tsx
│   │   │   │       └── service.ts
│   │   │   └── out
│   │   │       └── list
│   │   │           ├── index.tsx
│   │   │           └── service.ts
│   │   ├── index
│   │   │   ├── index.scss
│   │   │   └── index.tsx
│   │   ├── login
│   │   │   ├── index.scss
│   │   │   ├── index.tsx
│   │   │   └── service.ts
│   │   └── tabs
│   │       ├── home
│   │       │   ├── index.scss
│   │       │   ├── index.tsx
│   │       │   └── service.ts
│   │       ├── index.tsx
│   │       ├── mine
│   │       │   ├── address
│   │       │   │   ├── form
│   │       │   │   │   ├── index.scss
│   │       │   │   │   ├── index.tsx
│   │       │   │   │   └── service.ts
│   │       │   │   ├── index.scss
│   │       │   │   ├── index.tsx
│   │       │   │   └── service.ts
│   │       │   ├── index.scss
│   │       │   ├── index.tsx
│   │       │   ├── password
│   │       │   │   ├── index.scss
│   │       │   │   ├── index.tsx
│   │       │   │   └── service.ts
│   │       │   └── service.ts
│   │       └── msg
│   │           ├── index.scss
│   │           ├── index.tsx
│   │           └── service.ts
│   └── utils
│       ├── auth.ts
│       ├── cache
│       │   ├── cacheClass.ts
│       │   ├── index.ts
│       │   └── storage.ts
│       ├── index.ts
│       ├── location.ts
│       ├── navigateBack.ts
│       ├── network.ts
│       ├── qqmap-wx-jssdk.js
│       ├── qqmap-wx-jssdk.min.js
│       ├── scan.ts
│       ├── toast.ts
│       └── updateManager.ts
└── tsconfig.json

132 directories, 319 files

```
## 请求封装
```ts
http/config.ts
/*
 * @Author: hailong.chen
 * @Date: 2020-07-05 17:40:39
 * @Last Modified by:   hailong.chen
 * @Last Modified time: 2020-07-05 17:40:39
 * @Description: 多服务器
 */

export const  CONFIG = {
  // SERVER_URL: 'https://anymock.alipay.com/mockdata/http/116200003_4d1d518237d9bb00e5e2c2f41fb95c12',
  api_oss: 'https://',
  api_3pb: 'https://',
  api_b2b: 'https://',
  api_spd: 'https://',
  VERSION: ''
}

```
```ts
http/index.ts
/*
 * @Author: hailong.chen
 * @Date: 2020-07-05 17:40:39
 * @Last Modified by: hailong.chen
 * @Last Modified time: 2020-07-07 16:27:26
 * @Description: Description
 */

import Taro from '@tarojs/taro'
import {CONFIG} from "./config";
import {showToastError} from "../utils/toast";
import {IRes} from "commonType";
import qs from 'qs'
import {cache_Application_form_hosp} from "@/utils/cache";

const request = async (path = '', options): any => {
  let cookie = Taro.getStorageSync('Cookies')
  const {
    params: data,
    method,
    isUpload
  } = options

  try {
    let reqData = data
    let config = {}
    console.log('path',path)
    const urls = path.split('__')
    const url = `${CONFIG[`${urls[0]}`]}${urls[1]}`
    if (method === 'GET') {
      config = {
        header: {
          "Accept": 'application/json',
          'Cookie': cookie,
        },
      }
      const hosp = await cache_Application_form_hosp.get()
      //@ts-ignore
      config.header.hospId = hosp.id
    } else {
      if (isUpload) {
        config = {
          header: {
            "Accept": 'application/json',
            'Content-Type': 'multipart/form-data',
            'Cookie': cookie,
          },
        }
      } else {
        reqData = JSON.stringify(data)
        config = {
          header: {
            "Accept": 'application/json',
            'Content-Type': 'application/json;charset=utf-8',
            'Cookie': cookie,
          },
        }
      }
    }
    return new Promise((resolve, reject) => {
      const _url =  method === 'GET' ? `${url}?${qs.stringify(reqData)}` : url
      console.log(_url)
      const optionsReQ:any = {
        url: _url,
        method,
        ...config,
        data: reqData,
        credentials: "include",
        dataType: 'json',
        success: function (res: any) {
          const data = res.data
          if (data.returnCode === '000000') { // 处理cookie，微信不像h5那样一个 credentials: "include",就可以带上cookie需要特殊处理
            if(res.header['Set-Cookie']){
              let cookies = res.header['Set-Cookie'].replace(/,/g, ';')
              const _cookies = cookies.replace(/\s*/g,"").replace(/Domain=weimeng-hosp.com;|HttpOnly;|Path=\/;|HttpOnly/g,'')
              console.log(_cookies)
              Taro.setStorageSync('Cookies', _cookies)
            }

            resolve(data as IRes<any>)
          } else {
            if (data.returnCode === 'X0100006') {
              showToastError("登录超时，请到应用首页下拉刷新进行授权", 5000)
            } else {
              showToastError(data && (data.returnMessage || data.returnMessage), 3000)
            }
            resolve(data || {data: false})
          }
        },
        fail: function (res) {
          // console.log(res)
          // showToastError(CODE_MESSAGES[res.data.status], 3000)
          resolve({})
        },
      }
      if(method === 'GET'){
        delete optionsReQ.data
      }
      Taro.request(optionsReQ);
    })
  } catch (error) {
    console.log('err happen', error)

  }

}
export default request



```
```ts
http/message.ts
/*
 * @Author: hailong.chen
 * @Date: 2020-07-05 17:40:39
 * @Last Modified by: hailong.chen
 * @Last Modified time: 2020-07-05 17:41:56
 * @Description: Description
 */

export const ERRORS = {
  "11": "无权跨域",
  "12": "网络出错",
  "13": "请求超时",
  "14": "解码失败",
  "19": "HTTP错误",
}

export const CODE_MESSAGES = {
200: '服务器成功返回请求的数据。',
201: '新建或修改数据成功。',
202: '一个请求已经进入后台排队（异步任务）。',
204: '删除数据成功。',
400: '发出的请求有错误，服务器没有进行新建或修改数据的操作。',
401: '用户没有权限（令牌、用户名、密码错误）。',
403: '用户得到授权，但是访问是被禁止的。',
404: '发出的请求针对的是不存在的记录，服务器没有进行操作。',
406: '请求的格式不可得。',
410: '请求的资源被永久删除，且不会再得到的。',
422: '当创建一个对象时，发生一个验证错误。',
500: '服务器发生错误，请检查服务器。',
502: '网关错误。',
503: '服务不可用，服务器暂时过载或维护。',
504: '网关超时。',
};
```
## 分包处理

```ts
app.tsx
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-05-12 13:47:30
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-05-14 16:04:40
 * @Descripttion:
 */
import Taro, {Component, Config} from '@tarojs/taro'
import Index from './pages/index'
import 'taro-ui/dist/style/index.scss'
import './app.scss'
// import {networkType, networkStatus} from './utils/network'
// import {updateManager} from '@/utils/updateManager'

// 如果需要在 h5 环境中开启 React Devtools
// 取消以下注释：
// if (process.env.NODE_ENV !== 'production' && process.env.TARO_ENV === 'h5')  {
//   require('nerv-devtools')
// }

class App extends Component {

  componentDidMount() {
    // networkStatus()
    // updateManager()
  }

  componentDidShow() {
    // networkType()
  }

  componentDidHide() {
  }

  componentDidCatchError() {
  }

  /**
   * 指定config的类型声明为: Taro.Config
   *
   * 由于 typescript 对于 object 类型推导只能推出 Key 的基本类型
   * 对于像 navigationBarTextStyle: 'black' 这样的推导出的类型是 string
   * 提示和声明 navigationBarTextStyle: 'black' | 'white' 类型冲突, 需要显示声明类型
   */
  config: Config = {
    pages: [
      'pages/login/index',
      'pages/tabs/home/index',
      'pages/tabs/msg/index',
      'pages/tabs/mine/index',
      'pages/tabs/index',
      'pages/tabs/mine/password/index',
      'pages/tabs/mine/address/index',
      'pages/tabs/mine/address/form/index',
    ],
    tabBar: {
      // "custom": true,
      "color": "#c0c4cc",
      "selectedColor": "#000",
      // "backgroundColor": "#c0c4cc",
      "list": [{
        "pagePath": 'pages/tabs/home/index',
        "text": "首页",
        "selectedIconPath": "./assets/home_1.png",
        "iconPath": "./assets/home_0.png"
      }, {
        "pagePath": 'pages/tabs/msg/index',
        "text": "消息",
        "selectedIconPath": "./assets/msg_1.png",
        "iconPath": "./assets/msg_0.png"
      },
        {
          "pagePath": 'pages/tabs/mine/index',
          "text": "我的",
          "selectedIconPath": "./assets/mine_1.png",
          "iconPath": "./assets/mine_0.png"
        },
      ]
    },
    subPackages: [
      {
        "root": "pages/application/",
        "pages": [

          'mine/detail/index',
          'mine/list/index',
          'mine/products/index',
          'medical/detail/index',
          'medical/package/index',
          'medical/products/index',
          'mine/resume/index',
          'medical/form/index',
          'medical/hosp/index',
          'medical/transporters/index',
          'mine/remark/index',
        ]
      },
      {
        "root": "pages/backWH/",
        "pages": [
          'form/index',
          'list/index',
          'products/index',
          'submit/index',
          'snapshot/index',
          'detail/index',
          'inputCode/index',
        ]
      },
      {
        "root": "pages/clock/",
        "pages": [
          'out/list/index',
          'back/list/index',
          'common/resume/index',
          'common/detail/index',
          'common/products/index',
        ]
      }
    ],

    permission: {
      'scope.userLocation': {
        desc: '你的位置信息将用于小程序位置接口的效果展示'
      }
    },
    window: {
      backgroundTextStyle: 'light',
      navigationBarBackgroundColor: '#fff',
      navigationBarTitleText: 'WeChat',
      navigationBarTextStyle: 'black'
    }
  }
  // 在 App 类中的 render() 函数没有实际作用
  // 请勿修改此函数
  render() {
    return (
      <Index />
    )
  }
}

Taro.render(<App/>, document.getElementById('app'))



```

