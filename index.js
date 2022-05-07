var jsbridge = require('./jsbridge.js');

jsbridge.execMethod("echo", { k1: "v1" }, function (res) {
    console.log(res);
});
jsbridge.execMethod("echo", { k2: "v2", func: function () { } }, function (res) {
    console.log(res);
});
jsbridge.execMethod("unknown", { k3: "v3" }, function (res) {
    console.log(res);
});
