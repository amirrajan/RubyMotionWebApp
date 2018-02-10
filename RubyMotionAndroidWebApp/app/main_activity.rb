class MainActivity < Android::App::Activity
  URL = 'http://192.168.1.97:3000/welcome/celebrity'

  USER_AGENT = 'Mozilla/5.0 (Linux; U; Android 6.0.1; en-gb; Redmi 4A Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/46.0.2490.85 Mobile Safari/537.36 XiaoMi/MiuiBrowser/8.2.15'

  def onCreate(savedInstanceState)
    super

    #TODO: attach chrome debugger
    #Android::Webkit::WebView.setWebContentsDebuggingEnabled(true)

    web_stack = WebStack.new
    web_stack.context = self
    @web_view = web_stack.create_web_view
    @web_view.loadUrl(URL)
  end
end
