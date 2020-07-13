<!--
 * @version: v0.0.1
 * @Author: hailong.chen
 * @Date: 2020-03-16 18:28:26
 * @LastEditors: hailong.chen
 * @LastEditTime: 2020-03-17 22:51:08
 * @Descripttion: 
 -->
# 10.5 gulp

- [官网](https://www.gulpjs.com.cn/)
- [文章还不错](https://www.cnblogs.com/YuuyaRin/p/6165526.html)
- [gulp-watch](https://blog.csdn.net/guang_s/article/details/84672449)


- package.json
  
```json
  {
  "name": "recordcheckpro",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "gulp",
    "buildTest": "gulp buildTest",
    "build": "gulp build"
  },
  "author": "panxi",
  "license": "ISC",
  "devDependencies": {
    "browser-sync": "^2.26.7", // 方式2
    "gulp": "^3.9.1",
    "gulp-concat": "^2.6.1",
    "gulp-connect": "^5.5.0",
    "gulp-rev": "^8.1.1",
    "gulp-rev-collector": "^1.3.1",
    "gulp-sass": "^4.0.1",
    "gulp-uglify": "^1.5.4",
    "gulp-useref": "^3.1.5"
  },
  "dependencies": {
    "http-proxy-middleware": "^0.18.0"
  }
}

```

- gulpfile.js
  - 方式1 gulp + http-proxy-middleware + gulp-connect
  
```js
var gulp = require('gulp');
var uglify=require('gulp-uglify');
var concat = require('gulp-concat');
var gulpConnect = require('gulp-connect');
var fs = require('fs');
var rev = require('gulp-rev');
var revCollector = require('gulp-rev-collector');
var sass = require('gulp-sass');
var proxyMiddle = require('http-proxy-middleware');
var proxy = require('http-proxy-middleware');

gulp.task('default',['server','auto']);

//使用connect启动一个Web服务器
function deleteall(path) {
    var files = [];
    if(fs.existsSync(path)) {
        files = fs.readdirSync(path);
        files.forEach(function(file, index) {
            var curPath = path + "/" + file;
            if(fs.statSync(curPath).isDirectory()) { // recurse
                deleteall(curPath);
            } else { // delete file
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
    }
};

gulp.task('buildTest', function() {
	deleteall('test/js');
	deleteall('test/css');
	gulp.src([
		'src/js/utils/index.js',
		'src/js/config/server.js',
		'src/js/utils/isWeb.js',
		'src/js/actionType/index.js',
		'src/js/common/json2.js',
		'src/js/common/tableInfo.js',
		'src/js/common/jquery.min.js',
		'src/js/common/diff.min.js',
		'src/js/common/common.js',
		'src/js/contextComponent/DisaccordInfo.js',
		'src/js/contextComponent/IllegalInfo.js',
		'src/js/contextComponent/MissingInfo.js',
		'src/js/contextComponent/SameCaseInfo.js',
		'src/js/contextComponent/TimeWarningInfo.js',
		'src/js/contextComponent/VetoInfo.js',
		'src/js/contextComponent/outpatient.js',
		'src/js/index.js',
		'src/js/test/mockTest.js'])
		.pipe(concat('main.js'))
		.pipe(uglify({
			ie8: true,
		}))
		.pipe(gulp.dest("test/js"))
		.pipe(gulpConnect.reload());
//	gulp.src('src/assets/**').pipe(gulp.dest("test/assets"));
	gulp.src('src/css/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(gulp.dest("test/css"))
		.pipe(gulpConnect.reload());
	gulp.src('src/index.html')
		.pipe(gulp.dest("test"))
		.pipe(gulpConnect.reload());

	console.log("buildTest success!");
})

gulp.task('build', function() {
	deleteall('dist/js');
	deleteall('dist/css');
//	deleteall('dist/assets');
	gulp.src([
		'src/js/utils/index.js',
		'src/js/config/server.js',
		'src/js/utils/isWeb.js',
		'src/js/actionType/index.js',
		'src/js/common/json2.js',
		'src/js/common/tableInfo.js',
		'src/js/common/jquery.min.js',
		'src/js/common/diff.min.js',
		'src/js/common/common.js',
		'src/js/contextComponent/DisaccordInfo.js',
		'src/js/contextComponent/IllegalInfo.js',
		'src/js/contextComponent/MissingInfo.js',
		'src/js/contextComponent/SameCaseInfo.js',
		'src/js/contextComponent/TimeWarningInfo.js',
		'src/js/contextComponent/VetoInfo.js',
		'src/js/contextComponent/outpatient.js',
		'src/js/index.js'])
		.pipe(concat('main.js'))
		.pipe(uglify({
			ie8: true,
		}))
		.pipe(gulp.dest("dist/js"));
	gulp.src('src/assets/**')
		.pipe(gulp.dest("dist/assets"));

	gulp.src('src/css/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(gulp.dest("dist/css"));

	gulp.src('src/index.html')
		.pipe(gulp.dest("dist"));

	console.log("build success!");
})


gulp.task('server', function() {
	gulpConnect.server({
		root: 'test',
		port: 3000,
		livereload: true,
		middleware: function (connect, opt) {
			return [
				proxy('/mock',  {
					target: 'http://localhost:7001',
					changeOrigin:true
				}),
			]
		},
	})
})

gulp.task('auto', function () {
    gulp.watch(['src/js/**', 'src/css/*.scss', 'src/index.html'],['buildTest']);
});

// watch()第二参数是函数

```

  - 方式2 gulp + http-proxy-middleware + browser-sync

```js

var gulp = require('gulp');
var uglify=require('gulp-uglify');
var concat = require('gulp-concat');
var gulpConnect = require('gulp-connect');
var rev = require('gulp-rev');
var revCollector = require('gulp-rev-collector');
var sass = require('gulp-sass');
var proxy = require('http-proxy-middleware');
var clean = require('gulp-clean'); 

var sources = [
		'src/js/config/server.js',
		'src/js/utils/*.js',
		'src/js/actionType/index.js',
		'src/js/common/*.js',
		'src/js/contextComponent/*.js',
		'src/js/index.js'];

// 清空dist、test文件夹
gulp.task('clean', function(){
    return gulp.src(['dist/*', 'test/*'])
        .pipe(clean());
});

// 开发阶段
gulp.task('dev',['clean'], function() {
	gulp.src(sources)
		.pipe(concat('main.js'))
		.pipe(uglify({
			ie8: true,
		}))
		.pipe(gulp.dest("test/js"))
    
	gulp.src('src/css/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(gulp.dest("test/css"))
    
	gulp.src('src/index.html')
		.pipe(gulp.dest("test"))
})
// 打包发布
gulp.task('build',['clean'], function() {
	gulp.src(sources)
		.pipe(concat('main.js'))
		.pipe(uglify({
			ie8: true,
		}))
		.pipe(gulp.dest("dist/js"));
	gulp.src('src/assets/**')
		.pipe(gulp.dest("dist/assets"));
	gulp.src('src/css/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(gulp.dest("dist/css"));
	gulp.src('src/index.html')
		.pipe(gulp.dest("dist"));

	console.log("build success!");
})


//------------------------------------------ 方式2替换 -------------------------
var browserSync = require('browser-sync').create();

var jsonPlaceholderProxy = proxy('/mock', {
	target: 'http://localhost:7001',
	changeOrigin: true,             // for vhosted sites, changes host header to match to target's host
	// pathRewrite: {
	// 	'^': ''
	// },
	// logLevel: 'debug'
})

gulp.task('browser', function(){
	browserSync.init({
		server: './test' ,   // 访问目录
		// proxy: "你的域名或IP"    // 设置代理
		middleware: [jsonPlaceholderProxy]
	});
});
//------------------------------------------ 方式2替换 -------------------------

gulp.task('auto', function () {
    gulp.watch(['src/js/**', 'src/css/*.scss', 'src/index.html'],function(){
       gulp.start('dev'); // 文件发生变化，重新执行dev任务
       browserSync.reload(); // 异步加载
    });
});


gulp.task('default',['browser','auto', 'dev']); // 方式2替换          注释： default任务为gulp启动的任务
```




 - 方式3 gulp + http-proxy-middleware + browser-sync + 逻辑处理
  
```js

var gulp = require('gulp');
var uglify=require('gulp-uglify');
var concat = require('gulp-concat');
var gulpConnect = require('gulp-connect');
var rev = require('gulp-rev');
var revCollector = require('gulp-rev-collector');
var sass = require('gulp-sass');
var proxy = require('http-proxy-middleware');
var clean = require('gulp-clean'); 

// 清空dist、test文件夹
gulp.task('clean', function(){
    return gulp.src(['dist/*', 'test/*'])
        .pipe(clean());
});
// ================================================ develop 阶段  start =======================
var html_path = 'src/**/*.html';
var sass_path = 'src/css/*.scss';
var js_path = 'src/js/**';

// 监听
gulp.task('watch', function () {
    w(html_path, 'html');
    w(sass_path, 'sass');
    w(js_path, 'js');

    function w(path, task){
        watch(path, function () {
            gulp.start(task);
            browserSync.reload();
        });
    }
});


// html任务
gulp.task('html', function() {
    return gulp.src(html_path)
        .pipe(gulp.dest('dist'));
});
// sass任务
gulp.task('sass', function() {
    return gulp.src(sass_path)
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('test/css'));
});


var sources = [
		'src/js/config/server.js',
		'src/js/utils/*.js',
		'src/js/actionType/index.js',
		'src/js/common/*.js',
		'src/js/contextComponent/*.js',
		'src/js/index.js'];

// js  任务
gulp.task('js', function() {
  	// 打包文件依赖有先后顺序
    return gulp.src(sources)
		.pipe(concat('main.js'))
		.pipe(uglify({
			ie8: true,
		}))
    .pipe(gulp.dest("test/js"));
});


var browserSync = require('browser-sync').create();

var jsonPlaceholderProxy = proxy('/mock', {
	target: 'http://localhost:7001',
	changeOrigin: true,             // for vhosted sites, changes host header to match to target's host
	// pathRewrite: {
	// 	'^': ''
	// },
	// logLevel: 'debug'
})

gulp.task('browser', function(){
	browserSync.init({
		server: './test' ,   // 访问目录
		// proxy: "你的域名或IP"    // 设置代理
		middleware: [jsonPlaceholderProxy]
	});
});




gulp.task('default',['browser','watch']); // 开启浏览器同步任务，并启动监听任务
// ================================================ develop 阶段 end=======================


// ================================================ production 阶段 start=======================
// 全量打包
function buildFun(path){
	gulp.src(sources)
		.pipe(concat('main.js'))
		.pipe(uglify({
			ie8: true,
		}))
    .pipe(gulp.dest(path+"/js"));
    
	gulp.src('src/assets/**')
    .pipe(gulp.dest(path+"/assets"));
    
	gulp.src('src/css/*.scss')
		.pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(path+"/css"));
    
	gulp.src('src/index.html')
		.pipe(gulp.dest(path));

	console.log("build success!");
}

// 打包发布
gulp.task('build',['clean'],buildFun("dist"))

// ================================================ production 阶段 end=======================
```

*总结： 还是是没达到我想要的，gulp dest 耗性能，东西越多，越慢。增量更新才能解决，watch地方还可以再优化，咋整。。。*