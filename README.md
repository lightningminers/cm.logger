## cm.logger

JavaScript错误捕获，日志展示插件，不依赖任何库或框架，可选择在网页中展示，也可以在Native控制台中展示日志。

### 效果图

![](cm.logger.png)
---

### 使用

**注明：目前Native端只实现了iOS，使用NSURLProtocol**

方式一：在网页输出日志与错误信息

> 直接引入cm.logger.js，cm.logger.css

### JavaScript API

- log 传入一个任意数据，都将打印此字符串，undefined，null，NaN除外，此log不会展开递归。
- intensify 传入一个任意的数据，都将打印此字符串，如果是对象将展开递归，undefined，null，NaN除外。
- addTarget 网页版可用，传入一个事件回调，用于发送到服务端，无法修改事件，默认click。
- info 属性一个刷新周期内所打印或捕获的所有日志或错误信息。

```JavaScript
CMLogger.addTarget(function(e){
	//处理请求
});
```
