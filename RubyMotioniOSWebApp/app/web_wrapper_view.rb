class WebWrapperView < UIView
  URL = 'https://www.whatismybrowser.com'

  FALLBACK_USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1'

  def initWithFrame(frame)
    super
    create_web_view
    load_url
    self
  end

  def create_web_view(aConfiguration=nil)
    @web_views ||= []
    web_view = WKWebView.alloc.initWithFrame(self.frame, configuration:aConfiguration || WKWebViewConfiguration.new)
    web_view.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    web_view.navigationDelegate = self
    web_view.UIDelegate = self
    set_up_user_agent(web_view)
    addSubview(web_view)
    @web_views << web_view
    web_view
  end

  def set_up_user_agent(aWebView)
    if user_agent_set?
      aWebView.customUserAgent = @user_agent
      return
    end

    web_view = WKWebView.alloc.initWithFrame(CGRectZero)
    addSubview(web_view)
    web_view.evaluateJavaScript('navigator.userAgent', completionHandler:proc {|default_user_agent, error|
      web_view.removeFromSuperview
      user_agent = generate_user_agent_from_default(default_user_agent)
      aWebView.customUserAgent = user_agent
      self.user_agent = user_agent
    })
  end

  def load_url
    if user_agent_set?
      request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(url))
      @web_views[-1].loadRequest(request)
    else
      @pending_load_url = true
    end
  end

  def url
    URL
  end

  #Expecting:
  #  Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Mobile/14E269
  #Return something like:
  #  Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14E269 Safari/602.1
  def generate_user_agent_from_default(aString)
    return FALLBACK_USER_AGENT if !aString || aString.empty?
    matches = / OS ([\d_]+) .* AppleWebKit\/(.*) \(.*Mobile\/(.*)$/.match(aString)
    if matches && matches.size == 4
      os_version = matches[1].stringByReplacingOccurrencesOfString('_', withString: '.')
      browser_version = matches[2].split('.').first(2).join('.')
      model = matches[3]
      aString.stringByReplacingOccurrencesOfString("Mobile/#{model}", withString: "Version/#{os_version} Mobile/#{model} Safari/#{browser_version}")
    else
      FALLBACK_USER_AGENT
    end
  end

  #TODO: Would be good to store this somewhere and only regenerate occasionally (or never) for better startup performance
  def user_agent=(aString)
    @user_agent = aString
    if @pending_load_url
      @pending_load_url = false
      load_url
    end
  end

  def user_agent_set?
    @user_agent
  end

  ##WKNavigationDelegate

  def webView(aWebView, decidePolicyForNavigationAction:aWKNavigationAction, decisionHandler:block)
    block.call(WKNavigationActionPolicyAllow)
  end

  ##WKUIDelegate

  def webView(aWebView, createWebViewWithConfiguration:configuration, forNavigationAction:navigationAction, windowFeatures:windowFeatures)
    create_web_view(configuration)
  end

  def webViewDidClose(aWebView)
    aWebView.removeFromSuperview
    index = @web_views.index(aWebView)
    @web_views = @web_views[0...index] if index
  end
end
