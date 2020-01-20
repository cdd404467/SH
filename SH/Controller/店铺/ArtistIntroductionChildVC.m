//
//  ArtistIntroductionChildVC.m
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ArtistIntroductionChildVC.h"
#import "NetTool.h"
#import <WebKit/WebKit.h>


@interface ArtistIntroductionChildVC ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, copy) NSString *contentStr;
@end

@implementation ArtistIntroductionChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.leftBtn.hidden = YES;
    [self requestData];
}

//懒加载scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = UIColor.whiteColor;
        //150 + 680 + 6
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

#pragma mark 请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_ArtistShop_intro,_synopsisID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.contentStr = json[@"content"];
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) configuration:[self fitWebView]];
    _webView.scrollView.scrollEnabled = NO;
    _webView.navigationDelegate = self;
    [_webView loadHTMLString:self.contentStr baseURL:nil];
    [self.scrollView addSubview:_webView];
}

//网页适配屏幕
- (WKWebViewConfiguration *)fitWebView {
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    wkWebConfig.userContentController = wkUController;
    
    return wkWebConfig;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DDWeakSelf;
    [self.webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat height = [result doubleValue];
        weakself.webView.height = height;
        weakself.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, weakself.webView.bottom + 5);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.superview.frame;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
//    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidAppear {
//    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listWillDisappear {
//    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
//    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}
@end
