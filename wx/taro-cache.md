# 4. taro缓存

```ts
// storage.ts
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-05-12 11:31:29
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-05-13 14:19:35
 * @Descripttion:
 */
import Taro from '@tarojs/taro'
const storage = {
  setAsync: function(key, value){
    Taro.setStorageSync(key, value)
  },
  getAsync: function(key){
    return Taro.getStorageSync(key)
  },
  removeAsync: function(key){
    Taro.removeStorageSync(key)
  },
  setItem: function(key, value){
    Taro.setStorageSync(key, value)
  },
  getItem: function(key){
    return Taro.getStorageSync(key)
  },
  removeItem: function(key){
    Taro.removeStorageSync(key)
  },
}
export default storage

```

```ts
// cacheClass.ts
/**
 * @version: v0.0.2
 * @Author: hailong.chen
 * @Date: 2020-05-23 07:13:20
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-06-01 17:12:34
 * @Descripttion:
 */
import cache from './storage'

const storage = cache;

class CacheBase {
  protected key: string;

  constructor(key: string) {
    this.key = key;
  }

  set(value: any) {
    storage.setItem(this.key, value);
  }
  get() {
    return storage.getItem(this.key);
  }
  remove() {
    storage.removeItem(this.key);
  }
}

export class CacheStr extends CacheBase {
  constructor(key: string) {
    super(key);
  }
}

export class CacheArray extends CacheBase {
  constructor(key: string) {
    super(key);
  }

  set(value: any) {
    storage.setItem(this.key, value);
  }
  get() {
    return storage.getItem(this.key) || [];
  }
}

export class CacheObject extends CacheBase {
  constructor(key: string) {
    super(key);
  }

  set(value: any) {
    storage.setItem(this.key, value);
  }
  get() {
    return storage.getItem(this.key) || {};
  }
}
export class CacheInt extends CacheBase {
  constructor(key: string) {
    super(key);
  }

  // @ts-ignore
  get() {
    if (this.key) {
      // @ts-ignore
      const v = storage.getItem(this.key);
      const intValue = v === null ? undefined : +v;
      return intValue === intValue ? intValue : undefined;
    }
  }
}


```

```ts


import { CacheArray, CacheObject } from './cacheClass';
/**
 * object
 */
export const cache_mine_info= new CacheObject(
  'cache_mine_info',
);
/**
 * array
 */
export const cache_Application_mine_products = new CacheArray(
  'cache_Application_mine_products',
);

```

## 使用

```ts
// 存 cacheCurrentWarehouse.set({})
// 取 cacheCurrentWarehouse.get()
// 删 cacheCurrentWarehouse.remove()
//

```