# 18.1 h5适配

- ##### 物理像素(physical pixel)

  ```
  显示器(手机屏幕)上最小的物理显示单元
  ```

- ##### 设备独立像素(density-independent pixel)

  ```
  程序使用的虚拟像素(比如: css像素)
  ```

- ##### 设备像素比(device pixel ratio )

  ```设备像素比 = 物理像素 / 设备独立像素
  设备像素比 = 物理像素 / 设备独立像素
  
  window.devicePixelRatio获取到当前设备的dpr
  ```

以`iphone6`为例：

1. 设备宽高为`375×667`，可以理解为设备独立像素(或css像素)。
2. dpr为2，根据上面的计算公式，其物理像素就应该`×2`，为`750×1334`。



- 普通屏幕 vs retina屏幕

css像素所呈现的大小(物理尺寸)是一致的，不同的是1个css像素所对应的物理像素个数是不一致的



图片



##### retina下，图片高清问题

@2x的图片

可以类似这样，进行图片裁剪：

```
// 200×200
https://img.alicdn.com/tps/TB1AGMmIpXXXXafXpXXXXXXXXXX.jpg_200x200.jpg

// 100×100
https://img.alicdn.com/tps/TB1AGMmIpXXXXafXpXXXXXXXXXX.jpg_100x100.jpg
```

(ps: 当然裁剪只是对原图的等比裁剪，得保证图片的清晰嘛~)