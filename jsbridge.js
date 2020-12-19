var $ = require('nodobjc');

// import ObjC frameworks
$.framework('Foundation');
$.import("./ObjC/JavaScriptObjC/build/Release/JavaScriptObjC.framework");

var JSBridgeCallback = $.NSObject.extend('JSBridgeCallback');
JSBridgeCallback.addMethod('response:', 'v@:@', function (self, cmd, response) {
    var responseObj = JSON.parse(response);
    var id = responseObj.id;
    var data = responseObj.data;
    var callback = callbacks[id];
    callback(data);
});
JSBridgeCallback.register();

var callbacks = {};
var uniqueId = 1;
function execMethod(name, data, callback) {
    // setup NSAutoreleasePool
    var pool = $.NSAutoreleasePool('alloc')('init');

    var id = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
    if (callback) {
        callbacks[id] = callback;
    }
    data = JSON.parse(JSON.stringify(data));
    var message = JSON.stringify({
        name,
        data,
        id
    });

    var bridgeCallback = JSBridgeCallback('alloc')('init');
    $.JOBridge('postMessage', $(message), 'callback', bridgeCallback);

    pool('drain');
}

module.exports = {
    execMethod
};
