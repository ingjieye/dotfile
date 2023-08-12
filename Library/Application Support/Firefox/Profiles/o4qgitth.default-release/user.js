user_pref("widget.non-native-theme.scrollbar.style", 1);

//scroll speed
user_pref("mousewheel.default.delta_multiplier_x", 100);
user_pref("mousewheel.default.delta_multiplier_y", 100);
user_pref("mousewheel.default.delta_multiplier_z", 100);

//disable warning when opening about:config
user_pref("browser.aboutConfig.showWarning", false);

//try to fix PR_END_OF_FILE_ERROR by disable ipv6 
user_pref("network.dns.disableIPv6", true);

//use native full screen on macOS
user_pref("full-screen-api.macos-native-full-screen", true);

//always load userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

//always show bookmark bar
user_pref("browser.toolbars.bookmarks.visibility", "always");
