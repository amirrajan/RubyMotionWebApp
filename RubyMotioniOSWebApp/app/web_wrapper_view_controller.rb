class WebWrapperViewController < UIViewController
  def loadView
    super
    self.view = WebWrapperView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end
end
