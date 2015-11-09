var OneSpeakPlugin = function() {
};


// Call this to register for push notifications. Content of [options] depends on whether we are working with APNS (iOS) or GCM (Android)
OneSpeakPlugin.prototype.register = function(successCallback, errorCallback, options) {
    if (errorCallback == null) { errorCallback = function() {}}

    if (typeof errorCallback != "function")  {
        console.log("PushNotification.register failure: failure parameter not a function");
        return
    }

    if (typeof successCallback != "function") {
        console.log("PushNotification.register failure: success callback parameter must be a function");
        return
    }

    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin", "register", [options]);
};

// Call this to unregister for push notifications
OneSpeakPlugin.prototype.unregister = function(successCallback, errorCallback, options) {
    if (errorCallback == null) { errorCallback = function() {}}

    if (typeof errorCallback != "function")  {
        console.log("PushNotification.unregister failure: failure parameter not a function");
        return
    }

    if (typeof successCallback != "function") {
        console.log("PushNotification.unregister failure: success callback parameter must be a function");
        return
    }

    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin", "unregister", [options]);
};

// Call this if you want to show toast notification on WP8
OneSpeakPlugin.prototype.showToastNotification = function (successCallback, errorCallback, options) {
    if (errorCallback == null) { errorCallback = function () { } }

    if (typeof errorCallback != "function") {
        console.log("PushNotification.register failure: failure parameter not a function");
        return
    }

    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin", "showToastNotification", [options]);
};
// Call this to set the application icon badge
OneSpeakPlugin.prototype.setApplicationIconBadgeNumber = function(successCallback, errorCallback, badge) {
    if (errorCallback == null) { errorCallback = function() {}}

    if (typeof errorCallback != "function")  {
        console.log("PushNotification.setApplicationIconBadgeNumber failure: failure parameter not a function");
        return
    }

    if (typeof successCallback != "function") {
        console.log("PushNotification.setApplicationIconBadgeNumber failure: success callback parameter must be a function");
        return
    }

    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin", "setApplicationIconBadgeNumber", [{badge: badge}]);
};

//-------------------------------------------------------------------

if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.OneSpeakPlugin) {
    window.plugins.OneSpeakPlugin = new OneSpeakPlugin();
}

if (typeof module != 'undefined' && module.exports) {
    module.exports = OneSpeakPlugin;
}