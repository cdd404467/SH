//
//  ArtistWorksDetailsVC.m
//  SH
//
//  Created by i7colors on 2020/1/17.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ArtistWorksDetailsVC.h"
#import "NetTool.h"
#import "ArtistWorksModel.h"
#import <WebKit/WebKit.h>

@interface ArtistWorksDetailsVC ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ArtistWorksDetailModel *dataSource;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *specLab;
@property (nonatomic, strong) UILabel *priceLab;
@end

@implementation ArtistWorksDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"作品详情";
    self.navBar.backgroundColor = HEXColor(@"#333434", 1);
    self.navBar.backBtnTintColor = UIColor.whiteColor;
    self.navBar.titleLabel.textColor = UIColor.whiteColor;
    [self requestData];
    
}

//懒加载scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = UIColor.whiteColor;
        //150 + 680 + 6
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 400);
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_ArtistWorks_Details,_worksID];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
//        NSLog(@"------ %@",json);
        self.dataSource = [ArtistWorksDetailModel mj_objectWithKeyValues:json];
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = UIColor.blackColor;
    _nameLab.font = [UIFont systemFontOfSize:26];
    _nameLab.numberOfLines = 0;
    _nameLab.text = self.dataSource.originalName;
    [self.scrollView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(18);
    }];
    
    _specLab = [[UILabel alloc] init];
    _specLab.textColor = UIColor.blackColor;
    _specLab.font = [UIFont systemFontOfSize:16];
    _specLab.numberOfLines = 0;
    _specLab.text = [NSString stringWithFormat:@"尺寸: %@",self.dataSource.specs];;
    [self.scrollView addSubview:_specLab];
    [_specLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLab);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(22);
    }];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.textColor = UIColor.blackColor;
    _priceLab.font = [UIFont systemFontOfSize:16];
    _priceLab.numberOfLines = 0;
    _priceLab.text = [NSString stringWithFormat:@"价格: %@",self.dataSource.priceShow];
    [self.scrollView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLab);
        make.top.mas_equalTo(self.specLab.mas_bottom).offset(22);
    }];
    
    [_priceLab.superview layoutIfNeeded];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, _priceLab.bottom + 5, SCREEN_WIDTH, 200) configuration:[self fitWebView]];
    _webView.scrollView.scrollEnabled = NO;
    _webView.navigationDelegate = self;
    [_webView loadHTMLString:self.dataSource.richText.content baseURL:nil];
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

@end
