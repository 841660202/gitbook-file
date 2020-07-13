# 14. web缓存

```ts
// CacheClass.ts
/**
 * @version: v0.0.2
 * @Author: hailong.chen
 * @Date: 2020-05-23 07:13:20
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-06-01 17:12:34
 * @Descripttion:
 */
const storage = localStorage;

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
    storage.setItem(this.key, JSON.stringify(value));
  }
  get() {
    return JSON.parse(storage.getItem(this.key) || '[]');
  }
}

export class CacheObject extends CacheBase {
  constructor(key: string) {
    super(key);
  }

  set(value: any) {
    storage.setItem(this.key, JSON.stringify(value));
  }
  get() {
    return JSON.parse(storage.getItem(this.key) || '{}');
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

## 使用
```
/**
 * @version: v0.0.2
 * @Author: hailong.chen
 * @Date: 2020-05-23 07:13:07
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-06-03 09:10:06
 * @Descripttion:
 */

import { CacheInt, CacheArray, CacheStr, CacheObject } from './CacheClass';

/**
 * int
 */
export const cacheVirtualInSupplierId = new CacheInt(
  'cache_virtual_in_supplierId',
);

/**
 * string
 */
export const cacheVirtualInRemark = new CacheStr('cache_virtual_in_remark');

/**
 * Array
 */
export const cacheVirtualInProducts = new CacheArray(
  'cache_virtual_in_products',
);
/**
 * Object
 */
export const cacheCurrentWarehouse = new CacheObject('cache_current_warehouse');


```

### 使用

```ts
// 存 cacheCurrentWarehouse.set({})
// 取 cacheCurrentWarehouse.get()
// 删 cacheCurrentWarehouse.remove()
//

```

### 微信小程序略有不同见 taro-cache（/wx/taro-cache.html）