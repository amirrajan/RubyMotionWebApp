class WebStack
  attr_accessor :context, :user_agent

  def create_web_view
    web_view = Android::Webkit::WebView.new(context)
    web_view.webViewClient = Android::Webkit::WebViewClient.new
    web_chrome_client = WebChromeClient.new
    web_chrome_client.web_stack = self
    web_view.webChromeClient = web_chrome_client
    web_view.settings.userAgentString = user_agent if user_agent
    web_view.settings.javaScriptEnabled = true
    web_view.settings.supportMultipleWindows = true
    web_view.settings.databaseEnabled = true
    web_view.settings.domStorageEnabled = true

    context.contentView = web_view

    @stack ||= []
    @stack.push(web_view)

    web_view
  end

  def pop
    @stack.pop
    context.contentView = @stack.last
  end
end
