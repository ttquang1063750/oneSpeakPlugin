var OneSpeakPlugin = function() {};

// Call this if you want to show toast notification on WP8
OneSpeakPlugin.prototype.loadCustomData = function (successCallback, errorCallback, array_options) {
    if (errorCallback == null) { errorCallback = function () { } }
    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin", "loadCustomData", array_options);
};
// Call this to set the application icon badge
OneSpeakPlugin.prototype.customDataUpdateWithCommand = function(successCallback, errorCallback, array_options) {
    if (errorCallback == null) { errorCallback = function() {}}
    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin", "customDataUpdateWithCommand", array_options);
};

// Call this to set the application icon badge
OneSpeakPlugin.prototype.mapController = function(successCallback, errorCallback, array_options) {
    if (errorCallback == null) { errorCallback = function() {}}
    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin", "mapController", array_options);
};

OneSpeakPlugin.prototype.feed = function(successCallback, errorCallback, url) {
    if (errorCallback == null) { errorCallback = function() {}}
    cordova.exec(successCallback, errorCallback, "OneSpeakPlugin",  "feed", [{url:url}]);
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