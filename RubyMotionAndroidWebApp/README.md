WebWrapper
===
This sample demonstrates how to wrap a website with `WebView` and spoof the user agent so that it looks like requests came from an Android browser. It also demonstrates how to handle window.open() and window.close()

While we can set the user agent used by `WebView`, it doesn't affect XMLHttpRequests. See <https://developer.chrome.com/multidevice/webview/overview#how_do_i_set_the_user_agent_of_the_webview_>
