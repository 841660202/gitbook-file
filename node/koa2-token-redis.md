<!--
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-28 16:44:25
 * @LastEditors  : hailong.chen
 * @LastEditTime : 2019-12-28 18:50:32
 * @Descripttion: 
 -->
# koa2-token-redis

file: koa2-token-redis/README.md
```
[koa2+redis+jwt token验证，简单注册登录](https://www.cnblogs.com/wangzisheng/p/11362793.html)
```


file: koa2-token-redis/catalog.txt
```
.
├── README.md
├── catalog.txt
├── controller.js
├── controllers
│   ├── sign.js
│   └── user.js
├── index.js
├── model
│   ├── config.js
│   ├── paytoken.js
│   └── redis.js
├── package.json
└── test
    ├── GET.json
    └── api.http

3 directories, 12 files

```


file: koa2-token-redis/controller.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-26 15:46:07
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-28 17:00:07
 * @Descripttion: 
 */
const fs = require("fs");

function addMapping(router,mapping){
    for(let url in mapping){
        if(url.startsWith('GET')){
            //如果url类似get xxx
            let path = url.substring(4);
            router.get(path,mapping[url]);
        }
        else if(url.startsWith("POST")){
            //如果url 类似post xxx
            let path = url.substring(5);
            router.post(path,mapping[url]);
        }
        else{
            console.log(`invalid URL:${url}`);
        }
    }
}

function addControllers(router,dir){
    let files = fs.readdirSync(__dirname + "/" + dir);
    //过滤js文件
    let js_files = files.filter((f)=>{
        return f.endsWith(".js");
    });
    //处理每个js文件
    for(let f of js_files){
        let mapping = require(__dirname + '/controllers/' + f);
        addMapping(router,mapping);
    }
}

module.exports = function(dir){
    let controllers_dir = dir || "controllers";
    let router = require("koa-router")();
    addControllers(router,controllers_dir);
    return router.routes();
}
```


file: koa2-token-redis/index.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-26 15:42:28
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-27 00:09:53
 * @Descripttion: 
 */
const bodyParser = require("koa-bodyParser");
const Koa = require("koa");
const koaStatic = require("koa-static");
const path = require("path");
const cors = require("koa2-cors");
const koaJwt = require('koa-jwt');
// const
const token = require("./model/paytoken")
const constroller = require("./controller");
const config = require("./model/config");
const db = require("./model/redis");
const app = new Koa();

//全局配置
global.config = config;
global.db = db;
global.secret = "tokensecret";
//设置静态目录
app.use(koaStatic(path.resolve(__dirname,"./public")));
//跨域
app.use(cors());
//post 参数解析
app.use(bodyParser());
//token验证是否过期或失效
// app.use(token);
//容错处理
app.use((ctx,next)=>{
    return next().catch((error)=>{
        if(error.status === 401){
            ctx.status = 401;
            ctx.body = {
                code:-1,
                msg:"token error 401"
            }
        }
        else{
            throw error;
        }
    });
});
//token过滤规则
app.use(koaJwt({secret:global.secret}).unless({
    path:[
        /^\/api\/login/,
        /^\/api\/register/
        // /^\/api\/info/,
        // /^((?!\/api).)*$/
    ]
}));
//导入controller middleware
app.use(constroller());
//启动
app.listen(config.port);
console.log(`server start at ${config.port}`);
```


file: koa2-token-redis/package.json
```
{
  "name": "koa-server",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "start": "supervisor node index.js"
  },
  "keyword": [],
  "author": "hailong.chen",
  "license": "ISC",
  "dependencies": {
    "jsonwebtoken": "^8.5.1",
    "koa": "^2.11.0",
    "koa-bodyparser": "^4.2.1",
    "koa-jwt": "^3.6.0",
    "koa-router": "^7.4.0",
    "koa-static": "^5.0.0",
    "koa2-cors": "^2.0.6",
    "redis": "^2.8.0"
  }
}

```


file: koa2-token-redis/controllers/sign.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-26 15:46:28
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-26 17:44:20
 * @Descripttion: 
 */
const jwt = require('jsonwebtoken');
const db = global.db;
//注册路由
let register_func = async (ctx,next)=>{
    let name = ctx.request.body.userName;
    let password = ctx.request.body.password;
    let userdata = {name,password};
    let body;
    if(!name || !password){
        body = {
            code:-1,
            msg:"用户名或密码不能为空"
        }
    }
    else if(name.length < 4){
        body = {
            code:-1,
            msg:"用户名长度必须大于等于4"
        }
    }
    else if(password.length < 8){
        body = {
            code:-1,
            msg:"密码至少为8位"
        }
    }
    else{
        let data = await db.getKey(name);
        if(data){
            body = {
                code:-1,
                msg:"用户名重复",
            }
        }
        else{
            let result = await db.setKey(name,JSON.stringify(userdata));
            if(result){
                body = {
                    code:0,
                    msg:"注册成功",
                    token:jwt.sign(userdata,global.secret,{expiresIn:'4h'})
                }
            }
            else{
                body = {
                    code:-1,
                    msg:"注册失败，原因未知"
                }
            }
        }
    }
    ctx.body = body;
}
//登录路由
let login_func = async (ctx,next)=>{
    let name = ctx.request.body.userName || "";
    let password = ctx.request.body.password || "";
    if(!name || !password){
        ctx.body = {
            code:-1,
            msg:"用户名或密码错误"
        }
    }
    else{
        let result = await db.getKey(name);
        console.log("result:",result)
        let body;
        if(!result){
            body = {
                code:-1,
                msg:"用户不存在"
            }
        }
        else{
            let data = JSON.parse(result);
            if(data.password === password){
                body = {
                    code:0,
                    msg:"登录成功",
                    token:jwt.sign({name,password},global.secret,{expiresIn:'4h'})
                }
            }
            else{
                body = {
                    code:-1,
                    msg:"密码错误"
                }
            }
        }
        ctx.body = body;
    }
}

module.exports = {
    "POST /api/login":login_func,
    "POST /api/register":register_func
}
```


file: koa2-token-redis/controllers/user.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-26 15:46:28
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-26 18:27:31
 * @Descripttion:
 */
const jwt = require('jsonwebtoken');

//当前登录人路由
let info_func = async(ctx, next) => {
  // const token = ctx   .headers['authorization']   .replace("Bearer ", "");
  let authorization = ctx.header.authorization
  let token = authorization.split(' ')[1];
  let body = {}
  await jwt.verify(token, global.secret, async(error, decoded) => {
    if (error) {
      body = {
        code: 0,
        msg: error
      }
    } else {
      let data = await db.getKey(decoded.name);
      if (!!data) {
        body = {
          code: 1,
          msg: "获取信息成功",
          data: {
            name: decoded.name
          }
        }
      } else {
        body = {
          code: 1,
          msg: "token过期"
        }

      }

    }
    console.log("懵逼啊")
    console.log(body)
    console.log(ctx.response)
    ctx.body = body || {msg: "无语。。。"};
    return
  })
  
}
//当前登录人路由
let info1_func = async(ctx, next) => {
  console.log(ctx)
  ctx.body ={
    code: 1,
    msg: "ok",
  }
}
module.exports = {
  "GET /api/info": info_func,
  "GET /api/info1": info1_func,
}
```


file: koa2-token-redis/model/config.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-26 16:04:15
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-26 17:38:56
 * @Descripttion: 
 */
module.exports = {
  port: 8887,
  redis:{
    expire: 1200
  }
}
```


file: koa2-token-redis/model/paytoken.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-26 15:45:13
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-26 18:33:46
 * @Descripttion: 
 */
const jwt = require('jsonwebtoken');
async function verify(ctx,next){
    console.log("paytoken,",ctx);
    let url = ctx.request.url;
    let authorization = ctx.request.headers["authorization"];

    console.log("paytoken,",authorization);
    if(authorization){
        let token = authorization.split(" ")[1];
        let payload = jwt.verify(token,global.secret,(error,decoded)=>{
            if(error){
                ctx.body = {
                    status:-1,
                    msg:"登陆失效"
                };
            }
            else{
                ctx.token_data = decoded;
                return next();
            }
        });
    }
    else{
        return next();
    }
}

module.exports = verify;
```


file: koa2-token-redis/model/redis.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-26 15:55:13
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-26 17:43:49
 * @Descripttion:
 */
var redis = require('redis')
const {promisify} = require('util');
var client = redis.createClient()
const getAsync = promisify(client.get).bind(client);

client.on('error', function (err) {
  console.log('Error ' + err);
});

let setKey = async(key, val) => {
  console.log('setKey: key= ', key, 'val =', val);
  // 1 键值对

  const res = await client.set(key, val, redis.print);
  client.expire(key, global.config.redis.expire)
  console.log('redis: setkey',res)
  return res;

}
let getKey = (key) => {
  console.log('getKey: key =', key)

  return getAsync(key).then(function (res) {
    console.log(res); // => 'bar'
    return res
  });
}

module.exports = {
  setKey,
  getKey
}
```


file: koa2-token-redis/test/GET.json
```
{
  "request": {
    "method": "GET",
    "url": "/api/info",
    "header": {
      "user-agent": "vscode-restclient",
      "authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiMTU2NTE3MTIwNjUiLCJwYXNzd29yZCI6IjAwMHNkczAwMCIsImlhdCI6MTU3NzM1MTE5MiwiZXhwIjoxNTc3MzY1NTkyfQ.0TnOE7nrxtCxP5oGBNqhfoUSYOzdq_OmBtCG6n-G3Y4",
      "accept-encoding": "gzip, deflate",
      "cookie": "JSESSIONID=D2CACA650EF10A0C58E0226CEA9F8F4F",
      "host": "localhost:8887",
      "connection": "close"
    }
  },
  "response": {
    "status": 404,
    "message": "Not Found",
    "header": {
      "vary": "Origin",
      "access-control-allow-origin": "*"
    }
  },
  "app": {
    "subdomainOffset": 2,
    "proxy": false,
    "env": "development"
  },
  "originalUrl": "/api/info",
  "req": "<original node req>",
  "res": "<original node res>",
  "socket": "<original node socket>"
}
```


file: koa2-token-redis/test/api.http
```
@hostname = http://localhost
@port = 8887

@baseUrl = {{hostname}}:{{port}}/api
@contentType = application/json
@authToken= "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1NzczNDQ5NjUsImV4cCI6MTU3NzM1OTM2NX0.E2ROu6GVV0lnB_P4x0jH94AdSOKR_81kpifVnd_x714"

### 注册
POST {{baseUrl}}/register HTTP/1.1
Content-Type: {{contentType}}

{
  "userName": "15651712065",
  "password": "000sds000"
}


### 登陆
POST {{baseUrl}}/login HTTP/1.1
Content-Type: {{contentType}}

{
  "userName": "15651712065",
  "password": "000sds000"
}

### 获取信息
GET {{baseUrl}}/info HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiMTU2NTE3MTIwNjUiLCJwYXNzd29yZCI6IjAwMHNkczAwMCIsImlhdCI6MTU3NzQwODk1MywiZXhwIjoxNTc3NDIzMzUzfQ.sPTAEViy8XSIgnamsAraIruIZvG-rBWobsHmNk03XIg

### 获取信息1
GET {{baseUrl}}/info1 HTTP/1.1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiMTU2NTE3MTIwNjUiLCJwYXNzd29yZCI6IjAwMHNkczAwMCIsImlhdCI6MTU3NzQwODk1MywiZXhwIjoxNTc3NDIzMzUzfQ.sPTAEViy8XSIgnamsAraIruIZvG-rBWobsHmNk03XIg
```



