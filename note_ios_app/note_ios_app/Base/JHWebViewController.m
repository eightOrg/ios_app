//
//  LYWebViewController.m
//  LYWebViewController
//
//  Created by LvYuan on 16/7/9.
//  Copyright © 2016年 LvYuan. All rights reserved.
//

#import "JHWebViewController.h"
//#import "JH_ShareView.h"
@import WebKit;

#define kWebViewEstimatedProgress @"estimatedProgress"
#define kBackImageName @"backItemImage"
#define kBackImageNameHL @"backItemImageHL"
#define kItemSize 44.f
#define kBackWidth 46.f
#define kProgressDefaultTintColor [UIColor redColor]
#define kNavHeight 64.f

//扩展
@interface NSArray (Extension)

- (BOOL)exsit:(id)obj;

@end

@implementation NSArray (Extension)

- (BOOL)exsit:(id)object{
    
    for (id obj in self) {
        if (obj == object) {
            return true;
        }
    }
    return false;
}
@end



@interface JHWebViewController()<WKNavigationDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIBarButtonItem * backItem;

@property(nonatomic,strong)UIBarButtonItem * closeItem;

@property(nonatomic,strong)NSMutableArray * leftItems;

@property(nonatomic,strong)WKWebView * webView;

@property(nonatomic,strong)UIProgressView * progressView;
//项目中需求的分享按钮
@property(nonatomic,strong)UIBarButtonItem * shareItem;
//网页urlLabel
@property(nonatomic,strong)UILabel * urlLabel;
//WKContentView
@property(nonatomic,strong)UIView *wkContentView;

@end

@implementation JHWebViewController

//释放监听
- (void)dealloc{
    [_webView removeObserver:self forKeyPath:kWebViewEstimatedProgress];
}
//懒加载
-(UIView *)wkContentView{
    if (!_wkContentView) {
        for (UIView *subView0 in self.webView.scrollView.subviews) {
            if ([subView0 isKindOfClass:NSClassFromString(@"WKContentView")]) {
                _wkContentView = subView0;
            }
        }
    }
    return _wkContentView;
}

- (WKWebView *)webView{
    if (!_webView) {
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, self.view.bounds.size.width, self.view.bounds.size.height-kNavHeight)];
        //打开右滑回退功能
        _webView.allowsBackForwardNavigationGestures = true;
        //有关导航事件的委托代理
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}
-(UILabel *)urlLabel{
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        _urlLabel.numberOfLines = 0;
        _urlLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _urlLabel.textAlignment = NSTextAlignmentCenter;
        _urlLabel.font      = [UIFont systemFontOfSize:12];
        _urlLabel.textColor = [UIColor darkGrayColor];
        _urlLabel.center    = CGPointMake(self.view.frame.size.width/2, 20+kNavHeight);
        
    }
    return _urlLabel;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, kNavHeight - 1.5, self.view.bounds.size.width, 1.5);
        _progressView.tintColor = self.progressTintColor;
        [self.navigationController.view addSubview:_progressView];
        
    }
    return _progressView;
}

- (UIBarButtonItem *)closeItem{
    if (!_closeItem) {
        
        UIButton * close = [UIButton buttonWithType:UIButtonTypeSystem];
        [close setTitle:@"关闭" forState:UIControlStateNormal];
        close.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        close.frame = CGRectMake(0, 0, kItemSize, kItemSize);
        close.tintColor = self.navigationController.navigationBar.tintColor;
        [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        //close.backgroundColor = [UIColor lightGrayColor];
        _closeItem = [[UIBarButtonItem alloc]initWithCustomView:close];
        
    }
    return _closeItem;
}

- (UIColor *)progressTintColor{
    if (!_progressTintColor) {
        
        _progressTintColor = kProgressDefaultTintColor;
        
    }
    return _progressTintColor;
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        
        UIButton * back = [UIButton buttonWithType:UIButtonTypeSystem];
        [back setImage:[UIImage imageNamed:kBackImageName] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:kBackImageNameHL] forState:UIControlStateHighlighted];
        [back setTitle:@"返回" forState:UIControlStateNormal];
        back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        back.frame = CGRectMake(0, 0, kBackWidth, kItemSize);
        back.tintColor = self.navigationController.navigationBar.tintColor;
        [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        //back.backgroundColor = [UIColor lightGrayColor];
        _backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
        
    }
    return _backItem;
}

-(UIBarButtonItem *)shareItem{
    if (!_shareItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button addTarget:self action:@selector(_shareAction) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageCompressWithSimple:[UIImage imageNamed:@"分享"] scaledToSize:CGSizeMake(20, 20)] forState:0];
        _shareItem = item;
    }
    return _shareItem;
}
/**
 *  分享
 */
-(void)_shareAction{
//    JH_ShareView *share = [[JH_ShareView alloc] initWithFrame:CGRectMake(0,SCREENHEIGHT-SCREENWIDTH/4, SCREENWIDTH, SCREENWIDTH/4)];
//    
//    
//    share.webUrl = [NSString stringWithFormat:@"%@%@%@",BaseURL,BaseActivityShareURL,[NSString stringWithFormat:@"%@",self.activeId]];
//    [self.view addSubview:share];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self.view addSubview: self.urlLabel];
    [self.view addSubview: self.webView];

    //加载请求
    if (![self.urlString isKindOfClass:[NSNull class]]&&self.urlString!=nil&&![self.urlString isEqualToString:@""]) {
        /**
         webviewProgress
         */
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *reuqest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:reuqest];
        //为webView添加url展示
    }
    /**
     *  如果是含有html源码，将直接加载html源码
     */
    if (![self.tpl isKindOfClass:[NSNull class]]&&self.tpl!=nil) {
        
        
        [self.webView loadHTMLString:_tpl baseURL:nil];
        
    }
    //监听estimatedProgress
    [self.webView addObserver:self forKeyPath:kWebViewEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    
    //隐藏progressView
    self.progressView.hidden = true;
    
    //左items
    self.leftItems = [NSMutableArray arrayWithObject:self.backItem];
    
    self.closeItem.tintColor = self.navigationController.navigationBar.tintColor;
    //分享按钮
    if (self.activeId) {
    
        self.navigationItem.rightBarButtonItem = self.shareItem;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = !_webView.canGoBack;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_progressView removeFromSuperview];
    _progressView = nil;
    _closeItem = nil;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)setLeftItems:(NSMutableArray *)leftItems{
    _leftItems = leftItems;
    //显示左按钮
    [self setLeftItems];
}

- (void)setLeftItems{
    self.navigationItem.leftBarButtonItems = _leftItems;
}

- (void)showCloseItem{
    NSLog(@"Show");
    if (![_leftItems exsit:_closeItem]) {
        [self.leftItems addObject:_closeItem];
    }
    [self setLeftItems];
}
- (void)hiddenCloseItem{
    NSLog(@"Hidden");
    if ([_leftItems exsit:_closeItem]) {
        [self.leftItems removeObject:_closeItem];
    }
    [self setLeftItems];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    _progressView.progress = _webView.estimatedProgress;
}

#pragma mark - actions

- (void)close:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)back:(UIBarButtonItem *)sender{
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self close:nil];
    }
}

#pragma mark - navigation delegate

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    _progressView.hidden = false;
    self.navigationController.interactivePopGestureRecognizer.enabled = !_webView.canGoBack;
}

//内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
- (void)popGestureRecognizerEnable{
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
//        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        }
        
    }
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    _progressView.hidden = true;
    self.title = _webView.title;
    NSArray *arr1;
    NSArray *arr2;
    @try {
        arr1 = [_webView.URL.absoluteString componentsSeparatedByString:@"://"];
        arr2 = [arr1[1] componentsSeparatedByString:@"/"];
        
    } @catch (NSException *exception) {
        arr2 = @[@"未知的网页地址"];
    } @finally {
        self.urlLabel.text  = [NSString stringWithFormat:@"网页由%@提供",arr2[0]];
    }
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    if (!_webView.canGoBack) {
        [self popGestureRecognizerEnable];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = !_webView.canGoBack;
    
    if (_webView.canGoForward) {
        [self showCloseItem];
    }else{
        [self hiddenCloseItem];
    }
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    _progressView.hidden = true;
    
}

/**
 滚动的时候监听为了实现让往下移动的时候，让web中的nav跟着移动(有bug暂时不做)

 @param scrollView UIScrollView
 */

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    
//    if (scrollView.contentOffset.y<0) {
//        
//        CGFloat offset = scrollView.contentOffset.y;
//
//        self.wkContentView.top = -offset;
//    }
//    
//}



@end


