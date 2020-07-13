# 2. code2markdown

![](./images/6.gif)
file: code2markdown/catalog.txt
```
.
├── catalog.txt
├── index.js
├── package.json
├── test
│   ├── test1.js
│   └── test2.js
└── �\213�\225

2 directories, 5 files

```


file: code2markdown/config.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-28 17:28:46
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-28 18:24:52
 * @Descripttion: 
 */
const config = {
  // projectName: "koa2-token-redis",
  projectName: "",
  defaultProjectName: "code2markdown",
  outputPath: "",
  outputFileName: "",
  defaultOutputFileName: "myREADME.md",
}
module.exports = config
```


file: code2markdown/package.json
```
{
  "name": "code2markdown",
  "version": "1.0.0",
  "description": "根据项目结构生成markdown文件",
  "main": "index.js",
  "scripts": {
    "start": "supervisor node index.js"
  },
  "keyword": [],
  "author": "hailong.chen",
  "license": "ISC",
  "dependencies": {
    
  }
}

```


file: code2markdown/index.js
```
/**
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2019-12-28 17:02:31
 * @LastEditors: hailong.chen
 * @LastEditTime: 2019-12-28 18:24:26
 * @Descripttion:
 */
const fs = require("fs");
const path = require('path'); //解析需要遍历的文件夹
const chalk = require("chalk");
const config = require("./config")
const filePath = __dirname;

const defpath = path.join(__dirname, '../');

// console.log(chalk.cyan("项目绝对根目录")); console.log(defpath);
// console.log(chalk.cyan("项目根目录")); console.log(process.cwd());

console.log(chalk.bgMagenta("项目目录解读"));
let readPath = `${defpath}/${config.projectName || config.defaultProjectName}`;
let outputPath = `${defpath}/${config.outputPath || config.defaultOutputFileName}`;
console.log(readPath)
cleanOutputFile();
fileDisplay(readPath);
// import fs from 'fs'
function fileDisplay(filePath) {
    //根据文件路径读取文件，返回文件列表
    fs
        .readdir(filePath, function (err, files) {
            if (err) {
                console.warn(err)
            } else {
                //遍历读取到的文件列表
                files
                    .forEach(function (filename) {
                        //获取当前文件的绝对路径
                        var filedir = path.join(filePath, filename);
                        //根据文件路径获取文件信息，返回一个fs.Stats对象
                        fs.stat(filedir, function (eror, stats) {
                            if (eror) {
                                console.warn('获取文件stats失败');
                            } else {
                                var isFile = stats.isFile(); //是文件
                                var isDir = stats.isDirectory(); //是文件夹
                                if (isFile) {
                                    // 读取文件内容
                                    var content = fs.readFileSync(filedir, 'utf-8');
                                    //   console.log(content);
                                    const projectFileName = filedir.replace(defpath, "")
                                    console.log(projectFileName);
                                    // 添加代码格式开始标记
                                    // 添加文件名
                                    // 添加代码格式结束标记
                                    const mdContent = `\nfile: ${projectFileName}\n` +
"```"+
`
${content}
`+ 
"```"
                                    // 添加换行
                                    const addBr = mdContent + '\n\n'
                                    appendMd(addBr)
                                }
                                if (isDir) {
                                    if (filedir.includes("node_modules")) {
                                        console.log(chalk.bgRedBright("node_modules 无需解读"))
                                        return
                                    }
                                    fileDisplay(filedir); //递归，如果是文件夹，就继续遍历该文件夹下面的文件
                                }
                            }
                        })
                    });
            }
        });
}
function cleanOutputFile() {
    console.log('outputPath:',outputPath)
    if(fs.existsSync(outputPath)){
        fs.unlink(outputPath,(err) => {
            if (err) {
              console.log(err);
            } else {
              console.log('delete ok');
            }
          });
    }
}
function appendMd(data) {
    fs
        .appendFile(outputPath, data, 'utf8', function (err, ret) {

            if (err) {

                throw err

            }

            console.log('success')

        })

}
// //过滤js文件 let js_files = files.filter((f)=>{     return f.endsWith(".js"); });
// console.log(js_files)
```


file: code2markdown/test/test2.js
```

```


file: code2markdown/test/test1.js
```

```

