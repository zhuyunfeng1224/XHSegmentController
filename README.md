# XHSegmentController
这是一款分段选择控制器，分'XHSegmentViewController'和'XHSegmentControl'两部分<br>
XHSegmentViewController通过添加子Controller实现，可以通过左右滑动页面来滑动选择器，适合用自定义segment来管理不同的页面<br>
当然为了做到控件尽量轻量级，你也可以作为一个控件，单独使用'XHSegmentControl'
##XHSegmentViewController
XHSegmentViewController使用如下，自定义ViewController并继承XHSegmentViewController，设置viewControllers属性<br>
要点：要设置子ViewController的title，否则字体显示不出<br>
     ViewController *vc1 = [[ViewController alloc] init];
    vc1.title = @"男装";
    
    ViewController *vc2 = [[ViewController alloc] init];
    vc2.title = @"女装";
    
    ViewController *vc3 = [[ViewController alloc] init];
    vc3.title = @"童装";
    
    self.viewControllers = @[vc1, vc2, vc3];
##XHSegmentControl
XHSegmentControl是一个UIView类型的控件，可以设置控件背景色，添加底部高亮线，并设置标题字体和颜色等<br>
有两种模式可通过segmentType属性来设置<br>
分别是
   XHSegmentTypeFilled = 0,    //  充满屏幕高度
    XHSegmentTypeFit,           //  适应文字大小
    XHSegmentTypeCircle         //  循环  (待做)
XHSegmentControlDelegate是segmentControl代理，包含方法
- (void)xhSegmentSelectAtIndex:(NSInteger)index animation:(BOOL)animation;
可用来接受segment选择事件
