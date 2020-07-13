# 4. excelMergeCell2Data


file: excelMergeCell2Data/a.xlsx
```
.xlsx后缀的文件不予解析
```


file: excelMergeCell2Data/index.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-11-21 20:56:09
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-01-03 14:44:51
 * @Descripttion: 带有合并单元格数据处理，生成json数据
 * 此处excel文件解析，可优化为某文件夹下的excel到对应的out目录下对应文件名数据
 */
const xlsx = require('./node_modules/_node-xlsx@0.15.0@node-xlsx/lib');

// 1、获取解析文档
const sheets = xlsx.parse('./a.xlsx');
// 1、输出位置
const filepath = "./out/data.json"

function writeFile(filepath, data) {
  const fs = require("fs");
  fs.writeFile(filepath, JSON.stringify(data), error => {
    if (error) 
      return console.log("写入文件失败,原因是" + error.message);
    console.log("写入成功");
  });
}

// 表格1
const sheet = sheets[0]
const data = []
let groupId = 0;
let groupName = ""
let count = 0
for (var rowId in sheet['data']) {
  // 第一个行是表头丢掉
  if (rowId === "0") 
    continue
    // 取行
  var row = sheet['data'][rowId];
  // 合并单元格的一级类别
  if (row[0]) {
    groupName = row[0]
    groupId = count++;
    const obj = {
      text: groupName,
      id: groupId,
      indeterminate: false,
      checkedAll: false,
      child: [
        {
          text: row[1],
          id: count++
        }
      ]
    }
    data.push(obj)
  } else {
    // 二级类别
    const lastGroup = data[data.length - 1];
    const childItem = {
      text: row[1],
      id: count++
    }
    lastGroup
      .child
      .push(childItem)
  }
}
// 写数据
writeFile(filepath, data)

```


file: excelMergeCell2Data/package.json
```
{
  "name": "excel",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "node-xlsx": "^0.15.0"
  }
}

```


file: excelMergeCell2Data/out/data.js
```


export const REJECT_TYPES = [
  {
    text: '首页基本信息',
    id: 0,
    indeterminate: false,
    checkedAll: false,
    child:[
      {
        text: '姓名有误或未填',
        id: 1,
      },
      {
        text: '性别有误或未填',
        id: 2,
      },
      {
        text: '年龄有误或未填',
        id: 3,
      },
      {
        text: '出生地有误或未填',
        id: 4,
      },
      {
        text: '婚姻有误或未填',
        id: 5,
      },
    ]
  },
  {
    text: '首页住院过程信息',
    id: 6,
    indeterminate: false,
    child:[
      {
        text: '离院方式有误或未填',
        id: 7,
      },
      {
        text: '转科有误或未填',
        id: 8,
      },
      {
        text: '入院途径有误或未填',
        id: 9,
      },
    ]
  },
  {
    text: '首页诊疗信息',
    id: 10,
    indeterminate: false,
    child:[
      {
        text: '诊疗信息不全或未填',
        id: 11,
      },
      {
        text: '手术操作信息有误或未填',
        id: 12,
      }
    ]
  },
  {
    text: '首页其他信息',
    id: 13,
    indeterminate: false,
    child:[
      {
        text: '费用信息有误或未填',
        id: 14,
      },
      {
        text: '药物过敏有误或未填',
        id: 15,
      },
      {
        text: '血型有误或未填',
        id: 16,
      },
      {
        text: '转归有误或未填',
        id: 17,
      },
      {
        text: '省五项有误或未填',
        id: 18,
      }
    ]
  },
  {
    text: '住院病历',
    id: 19,
    indeterminate: false,
    child:[
      {
        text: '一般体格检查不全',
        id: 20,
      },
      {
        text: '住院病历不全',
        id: 21,
      },
      {
        text: '特评表不全',
        id: 22,
      },
      {
        text: '专科检查不全',
        id: 23,
      }
    ]
  },
  {
    text: '病程记录',
    id: 24,
    indeterminate: false,
    child:[
      {
        text: '转科记录不全',
        id: 25,
      },
      {
        text: '死亡病例讨论不全',
        id: 26,
      },
      {
        text: '首次病程记录不全',
        id: 27,
      },
      {
        text: '查房记录不全',
        id: 28,
      },{
        text: '阶段小结不全',
        id: 29,
      },
      {
        text: '日常病程记录不全',
        id: 30,
      },
      {
        text: '出院病程不全',
        id: 31,
      }
    ]
  },
  {
    text: '围手术病程记录',
    id: 32,
    indeterminate: false,
    child:[
      {
        text: '术前讨论记录不全',
        id: 33,
      },
      {
        text: '手术安全核查表不全',
        id: 34,
      },
      {
        text: '麻醉记录不全',
        id: 35,
      },
      {
        text: '术前小结不全',
        id: 36,
      },{
        text: '术后主刀查房记录不全',
        id: 37,
      },
      {
        text: '术前主刀查房不全',
        id: 38,
      },
      {
        text: '手术知情同意书不全',
        id: 39,
      },
      {
        text: '麻醉知情同意书不全',
        id: 40,
      },
      {
        text: '手术记录不全',
        id: 41,
      },
      {
        text: '术后首次病程记录不全',
        id: 42,
      },
    ]
  },
  {
    text: '出院记录',
    id: 43,
    indeterminate: false,
    child:[
      {
        text: '出院记录信息不全或有误',
        id: 44,
      },
      {
        text: '死亡记录信息',
        id: 45,
      },
    ]
  },
  {
    text: '各类知情同意书',
    id: 46,
    indeterminate: false,
    child:[
      {
        text: '72小时谈话不全',
        id: 47,
      },
      {
        text: '输血知情同意书不全',
        id: 48,
      },
      {
        text: '知情同意书不全',
        id: 49,
      },
    ]
  },
  {
    text: '会诊单',
    id: 50,
    indeterminate: false,
    child:[
      {
        text: '医嘱开具会诊单不全',
        id: 51,
      },
    ]
  },
  {
    text: '病理报告',
    id: 52,
    indeterminate: false,
    child:[
      {
        text: '免疫组化不全',
        id: 53,
      },
      {
        text: '病理报告不全',
        id: 54,
      },
      {
        text: '基因报告不全',
        id: 55,
      },
      {
        text: '骨髓报告不全',
        id: 56,
      },
    ]
  },
  {
    text: '化验单',
    id: 57,
    indeterminate: false,
    child:[
      {
        text: '医嘱开具化验单不全',
        id: 58,
      },
    ]
  },
  {
    text: '检查单',
    id: 59,
    indeterminate: false,
    child:[
      {
        text: '医嘱开具检查单不全',
        id: 60,
      },
    ]
  },
  {
    text: '体温单',
    id: 61,
    indeterminate: false,
    child:[
      {
        text: '体温单不全',
        id: 62,
      },
    ]
  },
  {
    text: '医嘱单',
    id: 63,
    indeterminate: false,
    child:[
      {
        text: '长期医嘱不全',
        id: 64,
      },
      {
        text: '临时医嘱不全',
        id: 65,
      },
    ]
  },{
    text: '护理内容',
    id: 66,
    indeterminate: false,
    child:[
      {
        text: '护理入院评估不全',
        id: 67,
      },
      {
        text: '住院告知不全',
        id: 68,
      },
      {
        text: '护理记录不全',
        id: 69,
      },
      {
        text: '健康教育表',
        id: 70,
      },
    ]
  },
]

```


file: excelMergeCell2Data/out/data.json
```
[
  {
    "text": "首页基本信息",
    "id": 0,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "姓名有误或未填",
        "id": 1
      },
      {
        "text": "性别有误或未填",
        "id": 2
      },
      {
        "text": "年龄有误或未填",
        "id": 3
      },
      {
        "text": "出生地有误或未填",
        "id": 4
      },
      {
        "text": "婚姻有误或未填",
        "id": 5
      }
    ]
  },
  {
    "text": "首页住院过程信息",
    "id": 6,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "离院方式有误或未填",
        "id": 7
      },
      {
        "text": "转科有误或未填",
        "id": 8
      },
      {
        "text": "入院途径有误或未填",
        "id": 9
      }
    ]
  },
  {
    "text": "首页诊疗信息",
    "id": 10,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "诊疗信息不全或未填",
        "id": 11
      },
      {
        "text": "手术操作信息有误或未填",
        "id": 12
      }
    ]
  },
  {
    "text": "首页其他信息",
    "id": 13,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "费用信息有误或未填",
        "id": 14
      },
      {
        "text": "药物过敏有误或未填",
        "id": 15
      },
      {
        "text": "血型有误或未填",
        "id": 16
      },
      {
        "text": "转归有误或未填",
        "id": 17
      },
      {
        "text": "省五项有误或未填",
        "id": 18
      }
    ]
  },
  {
    "text": "住院病历",
    "id": 19,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "一般体格检查不全",
        "id": 20
      },
      {
        "text": "住院病历不全",
        "id": 21
      },
      {
        "text": "特评表不全",
        "id": 22
      },
      {
        "text": "专科检查不全",
        "id": 23
      }
    ]
  },
  {
    "text": "病程记录",
    "id": 24,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "转科记录不全",
        "id": 25
      },
      {
        "text": "死亡病例讨论不全",
        "id": 26
      },
      {
        "text": "首次病程记录不全",
        "id": 27
      },
      {
        "text": "查房记录不全",
        "id": 28
      },
      {
        "text": "阶段小结不全",
        "id": 29
      },
      {
        "text": "日常病程记录不全",
        "id": 30
      },
      {
        "text": "出院病程不全",
        "id": 31
      }
    ]
  },
  {
    "text": "围手术病程记录",
    "id": 32,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "术前讨论记录不全",
        "id": 33
      },
      {
        "text": "手术安全核查表不全",
        "id": 34
      },
      {
        "text": "麻醉记录不全",
        "id": 35
      },
      {
        "text": "术前小结不全",
        "id": 36
      },
      {
        "text": "术后主刀查房记录不全",
        "id": 37
      },
      {
        "text": "术前主刀查房不全",
        "id": 38
      },
      {
        "text": "手术知情同意书不全",
        "id": 39
      },
      {
        "text": "麻醉知情同意书不全",
        "id": 40
      },
      {
        "text": "手术记录不全",
        "id": 41
      },
      {
        "text": "术后首次病程记录不全",
        "id": 42
      }
    ]
  },
  {
    "text": "出院记录",
    "id": 43,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "出院记录信息不全或有误",
        "id": 44
      },
      {
        "text": "死亡记录信息",
        "id": 45
      }
    ]
  },
  {
    "text": "各类知情同意书",
    "id": 46,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "72小时谈话不全",
        "id": 47
      },
      {
        "text": "输血知情同意书不全",
        "id": 48
      },
      {
        "text": "知情同意书不全",
        "id": 49
      }
    ]
  },
  {
    "text": "会诊单",
    "id": 50,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "医嘱开具会诊单不全",
        "id": 51
      }
    ]
  },
  {
    "text": "病理报告",
    "id": 52,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "免疫组化不全",
        "id": 53
      },
      {
        "text": "病理报告不全",
        "id": 54
      },
      {
        "text": "基因报告不全",
        "id": 55
      },
      {
        "text": "骨髓报告不全",
        "id": 56
      }
    ]
  },
  {
    "text": "化验单",
    "id": 57,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "医嘱开具化验单不全",
        "id": 58
      }
    ]
  },
  {
    "text": "检查单",
    "id": 59,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "医嘱开具检查单不全",
        "id": 60
      }
    ]
  },
  {
    "text": "体温单",
    "id": 61,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "体温单不全",
        "id": 62
      }
    ]
  },
  {
    "text": "医嘱单",
    "id": 63,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "长期医嘱不全",
        "id": 64
      },
      {
        "text": "临时医嘱不全",
        "id": 65
      }
    ]
  },
  {
    "text": "护理内容",
    "id": 66,
    "indeterminate": false,
    "checkedAll": false,
    "child": [
      {
        "text": "护理入院评估不全",
        "id": 67
      },
      {
        "text": "住院告知不全",
        "id": 68
      },
      {
        "text": "护理记录不全",
        "id": 69
      },
      {
        "text": "健康教育表",
        "id": 70
      }
    ]
  }
]
```

