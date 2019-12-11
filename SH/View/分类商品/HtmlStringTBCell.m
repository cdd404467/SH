//
//  HtmlStringTBCell.m
//  SH
//
//  Created by i7colors on 2019/11/26.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HtmlStringTBCell.h"
#import <WebKit/WebKit.h>
#import "GoodsModel.h"

@interface HtmlStringTBCell()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HtmlStringTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
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

- (void)setupUI {
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) configuration:[self fitWebView]];
    _webView.scrollView.scrollEnabled = NO;
    _webView.navigationDelegate = self;
    [self.contentView addSubview:_webView];
}

- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    if (isRightData(model.goodsDetail)) {
        [_webView loadHTMLString:model.goodsDetail baseURL:nil];
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DDWeakSelf;
    [self.webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
      CGFloat height = [result doubleValue];
      weakself.webView.height = height;
      if (weakself.webView.height != weakself.model.cellHeight) {
          weakself.model.cellHeight = height;
          if (weakself.cellHeightBlock) {
              weakself.cellHeightBlock();
          }
      }
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HtmlStringTBCell";
    HtmlStringTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HtmlStringTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
