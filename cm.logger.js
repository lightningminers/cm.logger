/**
 * @time 2015年11月20日
 * @author icepy
 * @info 移动版log输出模型，不依赖任何框架与库
 */

'use strict';

(function(){
    var callback = null;
    var body = document.getElementsByTagName('body')[0];
    var children = body.children;
    var _window = window;
    var console = _window.console;
    var cmLogger = document.createElement('div');
    cmLogger.id = 'CMLogger';
    cmLogger.className = 'am-container';
    cmLogger.style.position = 'absolute';
    cmLogger.style.top = '0px';
    cmLogger.style.left = '0px';
    cmLogger.style.display = 'none';
    cmLogger.style.paddingTop = '10px';
    var sendMessageBut = document.createElement('button');
    sendMessageBut.id = 'CMSendMessageLogger';
    sendMessageBut.type = 'button';
    sendMessageBut.className = 'am-btn am-btn-success';
    sendMessageBut.appendChild(document.createTextNode('错误信息提交远程服务'));
    cmLogger.appendChild(sendMessageBut);
    sendMessageBut = null;
    var container = document.createElement('div');
    container.id = 'CMLoggerContainer';
    cmLogger.appendChild(container);
    body.appendChild(cmLogger);
    cmLogger = null;
    var CMLoggerDom = document.getElementById('CMLogger');
    var CMLoggerContainer = document.getElementById('CMLoggerContainer');
    var CMSendMessageLogger = document.getElementById('CMSendMessageLogger');
    CMSendMessageLogger.addEventListener('click',function(e){
        if (typeof callback === 'function') {
            callback(e);
        };
    });
    var info = [];
    var _info = [];
    var ctrlElement = function(){
        if (CMLoggerDom.style.display === 'block') {
            return false;
        };
        for (var i = 0,len = children.length;i<len;i++){
            var node = children[i];
            if (node.nodeType === 1 & node.nodeName !== 'SCRIPT') {
                if (node.getAttribute('id') !== 'CMLogger') {
                    node.style.display = 'none';
                };
            };
        }
        CMLoggerDom.style.display = 'block';
    }
    var sendToLogger = function(response){
        info.length = 0;
        var before = CMLoggerContainer.innerHTML
        var message = 'TYPE:'+response.k+'\r\n';
        if (response.l) {
            message += 'FILE:'+response.u+'\r\n';
            message += 'LINE:'+response.l+'\r\n';
        }else{
            if(response.u){
                message += 'AT FILE LINE:'+response.u+'\r\n';
            }else{
                message += 'NODE NAME:'+response.tag+'\r\n';
            }
        };
        message += 'ERROR MESSAGE:'+response.m;
        message = message.replace('<','&lt');
        message = message.replace('>','&gt');
        var sendData = '<pre>'+message+'</pre>';
        var all = before ? before+sendData : sendData;
        info.push(all);
        _info.push(all);
        CMLoggerContainer.innerHTML = info.join('');
        ctrlElement();
    };
    var sendToConsoleLogger = function(requestData){
        var XHR = new XMLHttpRequest();
        var sendData = window.JSON.stringify(requestData);
        XHR.open('POST','http://icepy.github.io/_ConsoleLogger',true);
        XHR.send(sendData);
    };
    window.addEventListener('error',function(e){
        sendToLogger({k:'error',m:e.message,u:e.filename,l:e.lineno});
        
    });
    document.addEventListener('load',function(e){
        //加载完成
    },true);
    document.addEventListener('error',function(e){
        sendToLogger({k:'load source error',m:e.target.src,tag:e.target.nodeName});
    },true);
    window.CMLogger = {
        /**
         * [intensify 递归版]
         * @param  {[*]} log [*]
         */
        intensify:function(log,native){
            var treeInfo = function(obj){
                var info = '';
                var tree = function(_obj){
                    var _info = '';
                    switch(Object.prototype.toString.call(_obj)){
                        case '[object Object]':
                            for(var _key in _obj){
                                var _value = _obj[_key];
                                _info += '键-----'+_key+'------\r\n';
                                switch(Object.prototype.toString.call(_value)){
                                    case '[object Object]':
                                        _info += tree(_value);
                                        break;
                                    case '[object Array]':
                                        _info += tree(_value);
                                        break;
                                    default:
                                        if (log == undefined || log == null || log == NaN) {
                                            log = 'undefined,null,NaN \r\n';
                                            break;
                                        };
                                        _info += '值-----'+_value.toString()+ '\r\n';
                                        break;
                                }
                            }
                            break
                        default:
                            if (log !== undefined && log !== null && log !== NaN) {
                                log = 'undefined,null,NaN \r\n';
                                break;
                            };
                            _info += '值-----'+_obj.toString() + '\r\n';
                            break;
                    }
                    return _info
                }
                for(var key in obj){
                    var value = obj[key];
                    info += '\r\n键----start-----'+key+'------\r\n\r\n';
                    info += tree(value);
                    info += '\r\n\r\n------end----------\r\n'
                }
                return info;
            }
            switch(Object.prototype.toString.call(log)){
                case '[object Object]':
                    log = treeInfo(log);
                    break
                default:
                    if (log == undefined || log == null || log == NaN) {
                        log = 'undefined,null,NaN \r\n';
                        break;
                    };
                    log = log.toString() + '\r\n';
                    break;
            }
            var location = '';
            try{
                throw new Error();
            }catch(e){
                if (e&&e.stack) {
                    location = e.stack.replace(/Error\n/).split(/\n/)[1].replace(/^\s+|\s+$/, "");
                };
            }
            if (native) {
                sendToConsoleLogger({k:'intensify',u:location,m:log});
                return false;
            };
            sendToLogger({k:'intensify',u:location,m:log});
        },
        /**
         * [log 普通版]
         * @param  {[*]} log [*]
         */
        log:function(log,native){
            var info = '';
            var location = '';
            try{
                throw new Error();
            }catch(e){
                if (e&&e.stack) {
                    location = e.stack.replace(/Error\n/).split(/\n/)[1].replace(/^\s+|\s+$/, "");
                }
            }
            switch(Object.prototype.toString.call(log)){
                case '[object Object]':
                    log = JSON.stringify(log)+'\r\n';
                    break;
                case '[object Array]':
                    log = JSON.stringify(log)+'\r\n';
                    break;
                default:
                    if (log == undefined || log == null || log == NaN) {
                        log = 'undefined,null,NaN \r\n';
                        break;
                    };
                    log = log.toString() + '\r\n';
                    break;
            }
            if (native) {
                sendToConsoleLogger({k:'log',u:location,m:log});
                return false;
            };
            sendToLogger({k:'log',u:location,m:log})
        },
        /**
         * [addTarget 添加一个事件回调函数，全局加一次就好]
         * @param {Function} callback [description]
         */
        addTarget:function(callback){
            callback = callback;
        },
        info:_info,
        version:'0.0.1'
    }
})();