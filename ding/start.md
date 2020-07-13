# 3. 秒启动

>\* （读缓存进行渲染）
>
>\* 1、获取权限点 根据返回码与当前页信息决定是否进行重新授权登录
>
>\* 2、token超时=》重新授权
>
>\* 3、token未超时直接往下执行

```js
// 请求工具



/**
 * @Author hailong.chen
 * @Date 2018/12/10 10:02:05
 * @Description: 封装写了两遍，钉钉小程序编译时常量，非运行时常量
 */
import {AUTH_URL, codeMessage, ERRORS, SERVER_URL, VERSION} from "./server.data";
import {showToastFail} from "../utils/toast";
import {getToken} from "../utils/token";
// import {authDing} from "./api";
// import {dingAuth} from "../utils/ding-auth";
var tryTime;

export default async (url = '', options) => {
  const {
    params: data,
    method,
    isUpload
  } = options


  const token = await getToken()
    try {
      let reqData = data
      let config = {}
      if(url === '/api/v1/ding/app/user/auth'){ // 授权
        url = url.indexOf('api') < 0 ? `${AUTH_URL}/api/${VERSION}${url}` : `${AUTH_URL}${url}`
      }else{ // 业务
        url = url.indexOf('api') < 0 ? `${SERVER_URL}/api/${VERSION}${url}` : `${SERVER_URL}${url}`
      }

      if (method === 'GET') {
        config = {
          headers: {
            Accept: 'application/json',
            TOKEN: token
          }
        }
      } else {
        if (isUpload) {
          config = {
            headers: {
              Accept: 'application/json',
              'Content-Type': 'multipart/form-data',
              TOKEN: token
            }
          }
        } else {
          reqData = JSON.stringify(data)
          config = {
            headers: {
              Accept: 'application/json',
              'Content-Type': 'application/json;charset=utf-8',
              TOKEN: token
            }
          }
        }
      }
      // 授权不需要token
      if(url.includes('/api/v1/ding/app/user/auth') || url.includes("/api/v1/user/login")){
       delete config.headers.TOKEN
      }
      // console.log(url)
      // console.log('参数：', reqData)
      return new Promise((resolve, reject) => {
        dd.httpRequest({
          url,
          method,
          data: reqData,
          ...config,
          dataType: 'json',
          success: function (res) {
            const data = res.data
            if (data.code === '000000') {
              resolve(data)
            } else {
              if(data.code === 'X0100006'){
                if(getCurrentPages().length !== 1){ // 获取当前页是否是首页-------------------------- 1
                  showToastFail("登录超时，请到应用首页下拉刷新进行授权", 5000)
                }else{
                  resolve({data: "auth again"}) // 需要重新授权------------------------------------- 2
                }
              }else{
                showToastFail(data && (data.message || data.message), 3000)
              }
              resolve(data || {data: false})
            }
          },
          fail: function (res) {
            // console.log(res)
            showToastFail(codeMessage[res.data.status], 3000)
            resolve({})
          },
          complete: function (res) {
            // dd.hideLoading();
          }
        });
      })
    } catch (error) {
       dd.alert({content: error })
      console.log('err happen', error)

    }
}

```

```js
/**
 * @Author hailong.chen
 * @Date 2019-08-01 09:50:17
 * @Description:
 */
// home
import {LOGISTIC_MENU} from "../../consts";
import {bindInfo, currentUser, currentUserPoints, departmentAll, getCovers, unread} from "./server";
import storage from "../../utils/storage";
import {isPoneAvailable} from "../../utils/util";
import {showToastFail, showToastSuccess} from "../../utils/toast";
import {showAlert} from "../../utils/alert";
import {ddAuth} from "../../utils/auth";
import {getToken} from "../../utils/token";
import config from '../../config'
const app = getApp()

Page({
  data: {
    nav_active: 0,
    msgCount: 0,
    NAV: [
      {
        icon: '/images/home/home_0.png',
        iconActive: '/images/home/home_1.png',
        title: '首页',
        _classNameIcon: '',
        badgeCount: 0,
        checked: true
      },
      {
        icon: '/images/home/msg_0.png',
        iconActive: '/images/home/msg_1.png',
        title: '消息',
        _classNameIcon: '',
        badgeCount: 0
      },
      {
        icon: '/images/home/mine_0.png',
        iconActive: '/images/home/mine_1.png',
        title: '我的',
        _classNameIcon: '',
        badgeCount: 0
      },
    ],
    LOGISTIC_MENU: [],
    show: false,
    showDeparts: false,
    // department: {},
    points: [],
    department: {departmentName: '请选择', departmentId: null},
    covers:[],
    mobile: '',
    loadingText: ''
  },
  onLoad() {
    this.setData({
      covers: storage.getAsync("covers"),
    })
    dd.setNavigationBar({
      title: this.data.NAV[0].title,
    });
    // const bindOk = await storage.getAsync('bindOk')
    this.setData({
      viewWheelWidth: dd.getSystemInfoSync().screenWidth - 4 + 'px',
      viewWidth: dd.getSystemInfoSync().screenWidth + 'px',
      viewHeight: app.globalData.SystemInfo.screenHeight - 60 - 60 + 'px',
      // show: !bindOk
    })
    // 从缓存渲染
    this.renderFromCache()
    this.initial()
    
  },
  // 从缓存渲染
  async renderFromCache(){
    const points = await storage.getAsync('points')
    this.filterMenu(points)
  },
  async initial() {
    const token = await getToken() // 是否存在token,不存存在说明没登录过-------------------------------------1
    if(config.release && !token){
      // 发布
      this.auth()    // 授权拿到新的token-------------------------------------1
    } else{
      // 开发
      this.initialData()
    }
  },
  async auth() {
    try {
      //TODO
      await this.setData({
        corpId: app.globalData.corpId,
        loading: true,
        loadingText: '初始化授权'
      })
      ddAuth(app.globalData.corpId,()=>{
        this.initialData()
        this.setData({loading: false})
      })
    } catch (error) {
      showAlert(error)
    }
  },
  async initialData(){
    const result = await this.getCurrentUserPoints()
    if(result === 'stop'){
      return
    }
    await this.getCurrentUser()
    this.interval()
    this.getCovers()
  },
  // 获取宣传图
  async getCovers() {
    const res = await getCovers()
    if (res && res.data) {
      storage.setAsync("covers", res.data)
      this.setData({
        covers: res.data || []
      })
    }
  },
  async getCurrentUser() {
    const res = await currentUser()
    if (res && res.data) {
      dd.stopPullDownRefresh()
      const user = res.data
      await storage.setAsync('user', user)
      this.setData({
        user
      })
      // 信息绑定查询 多写括号，便于测试
      if ((!user.mobile && user.departmentId === null)) {
        await storage.setAsync('bindOk', false)
        this.setData({
          show: true
        })
      } else {
        await storage.setAsync('bindOk', true)
        this.setData({
          show: false
        })
      }
    }
  },
  async getCurrentUserPoints() {
    const res = await currentUserPoints()
    if(res && res.data === "auth again"){
      this.auth()
      return 'stop'
    }
    if (res && res.data) {
      const points = res.data
      await storage.setAsync('points', points)
      this.setData({
        points
      })
      this.filterMenu(points)
    }
  },
  filterMenu(points){
    this.setData({
      LOGISTIC_MENU: LOGISTIC_MENU.filter(
        item=>(
          !item.auth ||
          points.some(point=>point===item.auth)
        )
      )
    })
  },
  async getDeparts() {
    const res = await departmentAll()
    if (res && res.data) {
      this.setData({
        departs: res.data
      })
    }
  },
  interval() {
    if (!timer) {
      this.getUnread()
    }
    var timer = setInterval(
      () => {
        this.getUnread()
      }, 1000 * 60 * 3)
  },
  async navCheck(e) {
    const {index: targetIndex} = e.currentTarget.dataset
    const {NAV: nav} = this.data
    dd.setNavigationBar({
      title: this.data.NAV[targetIndex].title,
    });
    this.setData({
      nav_active: targetIndex,
      NAV: nav.map((item, index) => {
        item.checked = index === targetIndex
        return item
      })
    })
  },
  nav(e) {
    const {path} = e.currentTarget.dataset;
    if(!path){
      showToastFail("开发中,暂不提供此功能")
      return
    }
    dd.navigateTo({
      url: path,
    })
  },
  async getUnread() {
    const res = await unread()
    this.data.NAV[1].badgeCount =  res ? res.data : 0
    this.setData({
      msgCount:  res? res.data : 0,
      NAV: this.data.NAV
    })
  },
  onChange(item) {
    this.setData({
      department: item
    })
  },
  async formSubmit(e) {
    const {value} = e.detail
    const {mobile, shortMobile, authCode} = value
    const {department} = this.data
    if (typeof department.departmentId !== 'number') {

      showToastFail('请选择您所在的科室')
      return
    }
    if (!isPoneAvailable(mobile)) {

      showToastFail('手机号码填写有误')
      return
    }
    if (!authCode) {

      showToastFail('请填写验证码')
      return
    }

    const params = {
      departmentId: department.departmentId,
      mobile,
      shortMobile,
      authCode
    }
    const res = await bindInfo(params)
    if (res && res.data) {
      this.setData({show: false})
      // saveToken(res.data.token)
      await this.initial()
      showToastSuccess("绑定成功")

    }
  },
  onPullDownRefresh() {
    this.auth()
  },

  // 选取科室
  onSelect(e) {
    const {item} = e.target.dataset
    const department = {departmentName: '请选择', departmentId: null}
    // this.onTab()
    this.setData({
      department: item === null ? department : item,
      showDeparts: false
    })
  },
  onTab() {
    this.setData({
      showDeparts: !this.data.showDeparts
    })
  },
  onInputMobile(e){
    const {value} = e.detail
    console.log(value)
    this.setData({mobile: value})
  }
});

```

