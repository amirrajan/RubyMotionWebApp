class WebChromeClient < Android::Webkit::WebChromeClient
  attr_accessor :web_stack

  def onCreateWindow(aWebView, isDialog, isUserGesture, resultMessage)
    puts "[DEBUG] Open"
    web_view = web_stack.create_web_view
    transport = resultMessage.obj
    transport.setWebView(web_view)
    resultMessage.sendToTarget
    true
  end

  def onCloseWindow(window)
    puts '[DEBUG] Close'
    web_stack.pop
    super
  end
end
