<!--
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 16:37:04
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 17:29:43
 * @Descripttion: 
 -->
# 9.3 微前端架构(qiankun)

- github : [https://github.com/umijs/qiankun](https://github.com/umijs/qiankun)
  
- 介绍： 

>An implementation of Micro Frontends, based on single-spa, but made it production-ready.


- 衍生：

   - @umijs/plugin-qiankun

>[!TIP]注意：误用死都不知道怎么死的
在umijs中使用版本匹配，否则各种奇葩的问题，无论是issue还是社群都不会得到你想要的解决方案，大多人都是以umi v2来说的；umi v3存在自动注入依赖的机制，

  > Umi 会自动检测 dependencies 和 devDependencies 里的 umi 插件，比如：{
  >"dependencies": {
  >  "@umijs/preset-react": "1"
  >}
>}
>那么 @umijs/preset-react 会自动被注册，无需在配置里重复声明。

- 区分
  
 - Umi@2 plugin for [qiankun](https://github.com/umijs/qiankun)
 - Umi@3 相应的 qiankun [插件请移步这里](https://github.com/umijs/plugins/tree/master/packages/plugin-qiankun)


从最近使用的一个项目来聊我对微前端的认识。

```
main

apps
  - app1
  - app2
  - app3

```
- 部署 
  - 结合 nginx+ docker 处理
- 结构
  - 项目结构：看起来和electron-vue项目是有类似的特点，一个主应用+子应用。
  - 业务能力：主应用负责整合子应用；子应用负责具体的业务
- 数据
  - 说的也就是model层了，在数据调试过程中，发现chrome插件只能从redux中看到主应用的store而无法查看子应用的store,但是功能是正常的，应该的多个store的原因
- 开发调试
  - 可以把自应用单独开发，到了整合部署的时候再放在启动多个，本地启动多个电脑发热厉害（16G）的内存能扛住几个项目同时运行，电脑损伤还是严重的

- 代码

#### main项目

```
main
  - src
    - layouts
      - index.tsx
    - models
      - app.tsx
    - pages
      - subAppContainer.tsx
    - services
      - app.ts
      - request.ts
  - mock
    - app.ts
  - .umirc.ts
  - .env
  - package.json

```
/main/src/layouts/index.tsx
```tsx
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 11:42:39
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 15:02:52
 * @Descripttion:
 */
import { Breadcrumb, Layout, Menu } from 'antd';
import { connect } from 'dva';
import React from 'react';
import { Link } from 'umi';
import style from './index.less';

const { Header, Content, Footer } = Layout;

const renderBreadCrumb = pathname => {
  let arr = pathname.split('/').slice(1);
  if (arr[0] === '') {
    arr[0] = 'Home';
  }
  return (
    <Breadcrumb className={style.breadcrumb}>
      {arr.map(name => {
        return <Breadcrumb.Item key={name}>{name}</Breadcrumb.Item>;
      })}
    </Breadcrumb>
  );
};

@connect(({ base }) => ({ base }))
export default class extends React.PureComponent {
  constructor(props) {
    super(props);
    const { dispatch } = props;
    dispatch({
      type: 'base/getApps',
    });
  }

  render() {
    const { location, children, base } = this.props;
    const { name, apps } = base;
    const selectKey = '/' + location.pathname.split('/')[1];
    return (
      <Layout className={style.layout}>
        <Header>
          <div className={style.logo}>{name}</div>
          <Menu
            theme="dark"
            mode="horizontal"
            // defaultSelectedKeys={['home']}
            // selectedKeys={[selectKey]}
            style={{ lineHeight: '64px' }}
          >
            {/* <Menu.Item key="/">
              <Link to="/">Home</Link>
            </Menu.Item> */}
            {(apps || []).map((app, index) => {
              // if (index === 2) {
              //   return (
              //     <Menu.Item key={app.base}>
              //       <Link to="/app3/123">{app.name}</Link>
              //     </Menu.Item>
              //   );
              // }
              return (
                <Menu.Item key={app.base}>
                  <Link to={app.base}>{app.name}</Link>
                </Menu.Item>
              );
            })}
          </Menu>
        </Header>
        <Content className={style.content}>
          {/* {renderBreadCrumb(location.pathname)} */}
          {// 加载master pages，此处判断较为简单，实际需排除所有子应用base打头的路径
            selectKey === '/' ? children : null}
          {(apps || []).length ? <div id="root-subapp"/> : null}
        </Content>
        <Footer className={style.footer}>Ant Design ©2019 Created by Ant UED</Footer>
      </Layout>
    );
  }
}




```
main/src/models/app.tsx

```tsx
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 12:43:24
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 14:25:07
 * @Descripttion:
 */
import { query } from '@/services/app';
import { qiankunStart } from 'umi';

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

export default {
  namespace: 'base',

  state: {
    name: 'qianduan',
    apps: [],
  },

  effects: {
    *getApps(_, { put }) {
      /*
       子应用配置信息获取分同步、异步两种方式
       同步有两种配置方式，1、app.js导出qiankun对象，2、配置写在umi配置文件中，可通过import @tmp/subAppsConfig获取
      */
      yield sleep(1000);
      const apps = yield query();
      yield put({
        type: 'getAppsSuccess',
        payload: {
          apps,
        },
      });

      // 模拟手动控制 qiankun 启动时机的场景, 需要 defer 配置为 true
      setTimeout(qiankunStart, 200);
    },
  },

  reducers: {
    getAppsSuccess(state, { payload }) {
      return {
        ...state,
        apps: payload.apps
      }
    },
  },
};


```

main/src/pages/subAppContainer.tsx
```tsx
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 12:37:46
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 12:37:59
 * @Descripttion:
 */
import React from 'react';

export default function() {
  return <div />;
}
```
mian/services/app.ts
```ts
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 12:40:43
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 12:41:07
 * @Descripttion:
 */
import request from './request';

export async function query() {
  return request('/apps');
}


```
mian/services/request.ts
```ts
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 12:40:52
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 12:40:53
 * @Descripttion:
 */
import { extend } from 'umi-request';

export default extend({
  prefix: '/api',
});


```

main/mock/app.ts
```ts
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 13:06:24
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 14:59:52
 * @Descripttion:
 */
export default {
  'GET /api/apps': [
    {
      name: '首页',
      entry: 'http://localhost:4000',
      base: '/',
      mountElementId: 'root-subapp-container',
    },
    {
      name: 'app1',
      entry: 'http://localhost:4001/app1',
      base: '/app1',
      mountElementId: 'root-subapp-container',
    },
    {
      name: 'app2',
      entry: 'http://localhost:4002/app2',
      base: '/app2',
      mountElementId: 'root-subapp-container',
      props: {
        testProp: 'test',
      },
    },
    {
      name: 'app3',
      entry: 'http://localhost:4003/app3',
      base: '/app3/:abc',
      mountElementId: 'root-subapp-container',
    },
  ],
};


```
main/.umirc.ts
```ts

/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 11:42:39
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 14:22:38
 * @Descripttion:
 */
import {IConfig} from 'umi-types';

// ref: https://umijs.org/config/
const config : IConfig = {
  treeShaking: true,
  proxy: {
    '/api': {
      target: 'http://localhost:4000',
      changeOrigin: true,
    },
    '/api/app1': {
      target: 'http://localhost:4001',
      changeOrigin: true,
    },
    '/api/app2': {
      target: 'http://localhost:4002',
      changeOrigin: true,
    },
  },
  routes: [
    {
      path: '/',
      component: '../layouts/index',
      routes: [
        {
          path: '/',
          component: '../pages/index'
        }
      ]
    }
  ],
  plugins: [
    // ref: https://umijs.org/plugin/umi-plugin-react.html
    [
      '@umijs/plugin-qiankun', {
        master: {
          // defer: true, // 是否异步渲染 jsSandbox: true, // 是否启用 js 沙箱 prefetch: true // 是否启用
          // prefetch 特性 注册子应用信息 apps: [   {     name: 'app1', // 唯一 id     entry:
          // '//localhost:7001', // html entry     base: '/app1', // app1
          // 的路由前缀，通过这个前缀判断是否要启动该应用，通常跟子应用的 base 保持一致     history: 'browser', // 子应用的
          // history 配置，默认为当前主应用 history 配置   },   {     name: 'app2',     entry: {
          // // TODO 支持 config entry       scripts: [],       styles: [],     },     base:
          // '/app2',   }, ], jsSandbox: true, // 是否启用 js 沙箱，默认为 false prefetch: true, //
          // 是否启用 prefetch 特性，默认为 true
        }
      }
    ],
    [
      'umi-plugin-react', {
        antd: true,
        dva: true,
        dynamicImport: {
          webpackChunkName: true
        },
        title: 'main',
        dll: false,
        locale: {
          enable: true,
          default: 'en-US'
        },
        // routes: {
        //   exclude: [/models\//, /services\//, /model\.(t|j)sx?$/, /service\.(t|j)sx?$/, /components\//]
        // }
        routes:[{
          path: '/app1',
          exact: true,
          component: './subAppContainer'
        }, {
          path: '/app2',
          exact: true,
          component: './subAppContainer'
        },
      ]
      }
    ]
  ],
}

export default config;


```

main/.env
```
BROWSER=none
ESLINT=1
PORT=4000
```
main/package.json
```
{
  "name": "main",
  "private": true,
  "scripts": {
    "start": "umi dev",
    "build": "umi build",
    "test": "umi test",
    "lint": "eslint {src,mock,tests}/**/*.{ts,tsx} --fix",
    "precommit": "lint-staged"
  },
  "dependencies": {
    "@umijs/plugin-qiankun": "^1.5.4",
    "antd": "^3.19.5",
    "dva": "^2.6.0-beta.6",
    "react": "^16.8.6",
    "react-dom": "^16.8.6",
    "umi-request": "^1.2.19"
  },
  "devDependencies": {
    "@types/jest": "^23.3.12",
    "@types/react": "^16.7.18",
    "@types/react-dom": "^16.0.11",
    "@types/react-test-renderer": "^16.0.3",
    "babel-eslint": "^9.0.0",
    "eslint": "^5.4.0",
    "eslint-config-umi": "^1.4.0",
    "eslint-plugin-flowtype": "^2.50.0",
    "eslint-plugin-import": "^2.14.0",
    "eslint-plugin-jsx-a11y": "^5.1.1",
    "eslint-plugin-react": "^7.11.1",
    "husky": "^0.14.3",
    "lint-staged": "^7.2.2",
    "react-test-renderer": "^16.7.0",
    "umi": "^2.9.0",
    "umi-plugin-react": "^1.8.0",
    "umi-types": "^0.3.0"
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "git add"
    ],
    "*.{js,jsx}": [
      "eslint --fix",
      "git add"
    ]
  },
  "engines": {
    "node": ">=8.0.0"
  }
}


```
#### app1 项目
```
app1
  - src
    - layouts
      - index.tsx
    - models
      - app.tsx
    - pages
      - subAppContainer.tsx
    - services
      - app.ts
      - request.ts
  - mock
    - app.ts
  - .umirc.ts
  - .env
```
app1/modules/app1_demo1.ts
```ts
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 15:10:37
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 15:18:11
 * @Descripttion:
 */

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

export default {
  namespace: 'app1_demo1',

  state: {
    name: '测试子项目model',
  },

  effects: {
    *getDemo1(_, { put }) {
      /*
       子应用配置信息获取分同步、异步两种方式
       同步有两种配置方式，1、app.js导出qiankun对象，2、配置写在umi配置文件中，可通过import @tmp/subAppsConfig获取
      */
      yield sleep(1000);
      yield put({
        type: 'getAppsSuccess',
        payload: {
        },
      });
    },
  },

  reducers: {
  },
};

```

app1/src/pages/document.ejs
```ejs
<!--
 - @version: v0.0.1
 - @Author: hailong.chen
 - @Date: 2020-04-04 12:19:52
 - @LastEditors: hailong.chen
 - @LastEditTime: 2020-04-04 14:32:33
 - @Descripttion:
 -->
 <!DOCTYPE html>
 <html lang="en">
   <head>
     <meta charset="UTF-8" />
     <meta http-equiv="X-UA-Compatible" content="IE=edge" />
     <meta
       name="viewport"
       content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"
     />
     <title>资产管理</title>
     <link rel="icon" href="/favicon.png" type="image/x-icon" />
   </head>
   <body>
     <noscript>Sorry, we need js to run correctly!</noscript>
     <div id="<%= context.config.mountElementId %>">
       <style>
         .page-loading-warp {
           padding: 120px;
           display: flex;
           justify-content: center;
           align-items: center;
         }
         .ant-spin {
           -webkit-box-sizing: border-box;
           box-sizing: border-box;
           margin: 0;
           padding: 0;
           color: rgba(0, 0, 0, 0.65);
           font-size: 14px;
           font-variant: tabular-nums;
           line-height: 1.5;
           list-style: none;
           -webkit-font-feature-settings: 'tnum';
           font-feature-settings: 'tnum';
           position: absolute;
           display: none;
           color: #1890ff;
           text-align: center;
           vertical-align: middle;
           opacity: 0;
           -webkit-transition: -webkit-transform 0.3s cubic-bezier(0.78, 0.14, 0.15, 0.86);
           transition: -webkit-transform 0.3s cubic-bezier(0.78, 0.14, 0.15, 0.86);
           transition: transform 0.3s cubic-bezier(0.78, 0.14, 0.15, 0.86);
           transition: transform 0.3s cubic-bezier(0.78, 0.14, 0.15, 0.86),
             -webkit-transform 0.3s cubic-bezier(0.78, 0.14, 0.15, 0.86);
         }

         .ant-spin-spinning {
           position: static;
           display: inline-block;
           opacity: 1;
         }

         .ant-spin-dot {
           position: relative;
           display: inline-block;
           font-size: 20px;
           width: 20px;
           height: 20px;
         }

         .ant-spin-dot-item {
           position: absolute;
           display: block;
           width: 9px;
           height: 9px;
           background-color: #1890ff;
           border-radius: 100%;
           -webkit-transform: scale(0.75);
           -ms-transform: scale(0.75);
           transform: scale(0.75);
           -webkit-transform-origin: 50% 50%;
           -ms-transform-origin: 50% 50%;
           transform-origin: 50% 50%;
           opacity: 0.3;
           -webkit-animation: antSpinMove 1s infinite linear alternate;
           animation: antSpinMove 1s infinite linear alternate;
         }

         .ant-spin-dot-item:nth-child(1) {
           top: 0;
           left: 0;
         }

         .ant-spin-dot-item:nth-child(2) {
           top: 0;
           right: 0;
           -webkit-animation-delay: 0.4s;
           animation-delay: 0.4s;
         }

         .ant-spin-dot-item:nth-child(3) {
           right: 0;
           bottom: 0;
           -webkit-animation-delay: 0.8s;
           animation-delay: 0.8s;
         }

         .ant-spin-dot-item:nth-child(4) {
           bottom: 0;
           left: 0;
           -webkit-animation-delay: 1.2s;
           animation-delay: 1.2s;
         }

         .ant-spin-dot-spin {
           -webkit-transform: rotate(45deg);
           -ms-transform: rotate(45deg);
           transform: rotate(45deg);
           -webkit-animation: antRotate 1.2s infinite linear;
           animation: antRotate 1.2s infinite linear;
         }

         .ant-spin-lg .ant-spin-dot {
           font-size: 32px;
           width: 32px;
           height: 32px;
         }

         .ant-spin-lg .ant-spin-dot i {
           width: 14px;
           height: 14px;
         }

         @media all and (-ms-high-contrast: none), (-ms-high-contrast: active) {
           .ant-spin-blur {
             background: #fff;
             opacity: 0.5;
           }
         }

         @-webkit-keyframes antSpinMove {
           to {
             opacity: 1;
           }
         }

         @keyframes antSpinMove {
           to {
             opacity: 1;
           }
         }

         @-webkit-keyframes antRotate {
           to {
             -webkit-transform: rotate(405deg);
             transform: rotate(405deg);
           }
         }

         @keyframes antRotate {
           to {
             -webkit-transform: rotate(405deg);
             transform: rotate(405deg);
           }
         }
       </style>
       <div class="page-loading-warp">
         <div class="ant-spin ant-spin-lg ant-spin-spinning">
           <span class="ant-spin-dot ant-spin-dot-spin"
             ><i class="ant-spin-dot-item"></i><i class="ant-spin-dot-item"></i
             ><i class="ant-spin-dot-item"></i><i class="ant-spin-dot-item"></i
           ></span>
         </div>
       </div>
     </div>
   </body>
 </html>


```
app1/.umirc.ts
```ts
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 11:42:39
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 14:20:48
 * @Descripttion:
 */
import {IConfig} from 'umi-types';

// ref: https://umijs.org/config/
const config : IConfig = {
  base: '/app1',
  publicPath: '/app1/',
  outputPath: './dist/app1',
  mountElementId: 'app1',
  treeShaking: true,
  routes: [
    {
      path: '/',
      component: '../layouts/index',
      routes: [
        {
          path: '/',
          component: '../pages/index'
        }
      ]
    }
  ],
  plugins: [
    // ref: https://umijs.org/plugin/umi-plugin-react.html
    ['@umijs/plugin-qiankun', { slave: {} }],
    [
      'umi-plugin-react', {
        antd: true,
        dva: true,
        dynamicImport: {
          webpackChunkName: true
        },
        title: 'app1',
        dll: false,
        locale: {
          enable: true,
          default: 'en-US'
        },
        routes: {
          exclude: [/models\//, /services\//, /model\.(t|j)sx?$/, /service\.(t|j)sx?$/, /components\//]
        }
      }
    ]
  ]
}

export default config;

```
app1/package.json
```json
{
  "name": "app1",
  "private": true,
  "scripts": {
    "start": "umi dev",
    "build": "umi build",
    "test": "umi test",
    "lint": "eslint {src,mock,tests}/**/*.{ts,tsx} --fix",
    "precommit": "lint-staged"
  },
  "dependencies": {
    "@umijs/plugin-qiankun": "^1.5.4",
    "antd": "^3.19.5",
    "dva": "^2.6.0-beta.6",
    "react": "^16.8.6",
    "react-dom": "^16.8.6"
  },
  "devDependencies": {
    "@types/jest": "^23.3.12",
    "@types/react": "^16.7.18",
    "@types/react-dom": "^16.0.11",
    "@types/react-test-renderer": "^16.0.3",
    "babel-eslint": "^9.0.0",
    "eslint": "^5.4.0",
    "eslint-config-umi": "^1.4.0",
    "eslint-plugin-flowtype": "^2.50.0",
    "eslint-plugin-import": "^2.14.0",
    "eslint-plugin-jsx-a11y": "^5.1.1",
    "eslint-plugin-react": "^7.11.1",
    "husky": "^0.14.3",
    "lint-staged": "^7.2.2",
    "react-test-renderer": "^16.7.0",
    "umi": "^2.9.0",
    "umi-plugin-react": "^1.8.0",
    "umi-types": "^0.3.0"
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "git add"
    ],
    "*.{js,jsx}": [
      "eslint --fix",
      "git add"
    ]
  },
  "engines": {
    "node": ">=8.0.0"
  }
}

```
app1/src/pages/index.tsx
```tsx
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 11:42:39
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 15:15:20
 * @Descripttion:
 */
import React from 'react';
import styles from './index.css';
import { formatMessage } from 'umi-plugin-locale';
import { connect } from 'dva';
import React from 'react';
@connect(({ app1_demo1 }) => ({ app1_demo1 }))
export default class extends React.PureComponent {


  render() {
    const { app1_demo1 } = this.props;
    const { name } = app1_demo1;
    return (
    <div>{name}</div>
    );
  }
}


```
app1/app.ts

```ts
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-04-04 11:42:39
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-04-04 14:07:48
 * @Descripttion:
 */
export const dva = {
  config: {
    onError(err: ErrorEvent) {
      err.preventDefault();
      console.error(err.message);
    },
  },
};

export const qiankun = {
  // 应用加载之前
  async bootstrap(props) {
    console.log('app1 bootstrap', props);
  },
  // 应用 render 之前触发
  async mount(props) {
    console.log('app1 mount', props);
  },
  // 应用卸载之后触发
  async unmount(props) {
    console.log('app1 unmount', props);
  },
};


```
app2 、 app3与app1结构一样，内容不同

  




