var exec = require('cordova/exec');

exports.startDownload = function(arg0, success, error) {
    exec(success, error, "BackgroundDownload", "startDownload", [arg0]);
};
