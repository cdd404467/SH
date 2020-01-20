//
//  MaterialDetailsVC.m
//  SH
//
//  Created by i7colors on 2019/11/27.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MaterialDetailsVC.h"
#import "NetTool.h"
#import <Somo.h>
#import "MaterialModel.h"
#import "UIView+Border.h"
#import <WebKit/WebKit.h>
#import "ImageLabView.h"
#import "UIButton+Extension.h"
#import "DesignerMainPageVC.h"
#import <YBImageBrowser.h>
#import <YBIBVideoData.h>
#import "CddHud.h"

@interface MaterialDetailsVC ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) MaterialModel *dataSource;
@property (nonatomic, strong) UIImageView *isCollectImg;
@property (nonatomic, strong) UIImageView *videoImg;
//应用素材
@property (nonatomic, strong) UIButton *applyBtn;
//查看设计师
@property (nonatomic, strong) UIButton *lookOverBtn;
@end

@implementation MaterialDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"素材详情";
    [self requestData];
}

//懒加载scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 7);
        //150 + 680 + 6
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

#pragma mark 请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Material_Details,_materialId];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [MaterialModel mj_objectWithKeyValues:json];
        
        self.dataSource.labelInfoList = [LabelModel mj_objectArrayWithKeyValuesArray:self.dataSource.labelInfoList];
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
    [self.scrollView addSubview:bgView];
    [bgView addBorder:HEXColor(@"#D6D6D6", 1) width:0.5 direction:BorderDirectionBottom];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.cornerRadius = 6.f;
    _imageView.clipsToBounds = YES;
    _imageView.frame = CGRectMake(15, 10, 90, 90);
    [bgView addSubview:_imageView];
    
    _isCollectImg = [[UIImageView alloc] init];
    _isCollectImg.image = [UIImage imageNamed:@"has_collect_icon"];
    _isCollectImg.hidden = YES;
    [bgView addSubview:_isCollectImg];
    [_isCollectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.imageView);
    }];

    _nameLab = [[UILabel alloc] init];
    _nameLab.font= [UIFont systemFontOfSize:16];
    _nameLab.textColor = HEXColor(@"#090203", 1);
    [bgView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10);
        make.top.mas_equalTo(self.imageView);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(22);
    }];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.textColor = HEXColor(@"#FF5100", 1);
    _priceLab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    [bgView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(1);
        make.height.mas_equalTo(28);
        make.left.right.mas_equalTo(self.nameLab);
    }];
    
    //描述介绍
    _detailLab = [[UILabel alloc] init];
    _detailLab.numberOfLines = 2;
    _detailLab.textColor = HEXColor(@"#9B9B9B", 1);
    _detailLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [bgView addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.bottom.mas_equalTo(self.imageView.mas_bottom).offset(0);
        make.right.mas_equalTo(self.isCollectImg);
    }];
    
    [self configData];
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"素材标签";
    txtLab.textColor = HEXColor(@"#4A4A4A", 1);
    txtLab.font = [UIFont systemFontOfSize:13];
    txtLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:txtLab];
    [txtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.imageView);
        make.top.mas_equalTo(bgView.mas_bottom).offset(14);
        make.height.mas_equalTo(16);
    }];
    
    CGFloat allWidth = SCREEN_WIDTH - 15 * 2 - 90 - 10;
    CGFloat width = 60;
    CGFloat gap = 5;
    CGFloat lineGap = 12;
    CGFloat height = 17;
    UIView *labView = [[UIView alloc] init];
    labView.frame = CGRectMake(15 + 90 + 10, bgView.bottom + 14, allWidth, 30);
    [self.scrollView addSubview:labView];
    NSInteger count = _dataSource.labelInfoList.count;
    //行数
    NSInteger line = 0;
    //每行第几个
    NSInteger lineCount = 0;
    //实际每行的宽度
    CGFloat lineWidth = 0;
    //实际的高度
    CGFloat lineHeight = 0;
    for (NSInteger i = 0; i < count; i++) {
        ImageLabView *signView = [[ImageLabView alloc] init];
        LabelModel *m = _dataSource.labelInfoList[i];
        signView.textLab.text = m.name;
        [labView addSubview:signView];
        signView.frame = CGRectMake(lineCount * (width + gap), line * (height + lineGap), width, height);
        lineWidth += width + gap;
        if (lineWidth > allWidth) {
            lineCount = 0;
            line ++;
            signView.left = lineCount * (width + gap);
            signView.top = line * (height + lineGap);
        }
        lineHeight = signView.bottom;
    }
    labView.height = lineHeight;

    
    if (isRightData(_dataSource.video)) {
        UIImageView *videoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, labView.bottom + 25, SCREEN_WIDTH, 210)];
        videoImg.backgroundColor = Like_Color;
        UIImageView *playImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playVideo_icon"]];
        [videoImg addSubview:playImg];
        [videoImg sd_setImageWithURL:ImgUrl_SD_OSS(_dataSource.videoImg, (int)SCREEN_WIDTH) placeholderImage:PlaceHolderImg];
        [HelperTool addTapGesture:videoImg withTarget:self andSEL:@selector(videoTap)];
        [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(videoImg);
            make.width.height.mas_equalTo(64);
        }];
        [self.scrollView addSubview:videoImg];
        _videoImg = videoImg;
    }
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) configuration:[self fitWebView]];
    if (isRightData(_dataSource.video)) {
        _webView.top = _videoImg.bottom + 8;
    } else {
        _webView.top = labView.bottom + 25;
    }
    _webView.scrollView.scrollEnabled = NO;
    _webView.navigationDelegate = self;
    [_webView loadHTMLString:_dataSource.richText baseURL:nil];
    [self.scrollView addSubview:_webView];
    
    
    //最底部的按钮
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(56);
    }];
    DDWeakSelf;
    _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _applyBtn.layer.cornerRadius = 20.f;
    [_applyBtn addEventHandler:^{
        [CddHud showTextOnly:@"该素材不可用" view:weakself.view];
    }];
    _applyBtn.layer.borderColor = HEXColor(@"#ECECEC", 1).CGColor;
    _applyBtn.layer.borderWidth = 1.f;
    _applyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_applyBtn setTitleColor:HEXColor(@"#090203", 1) forState:UIControlStateNormal];
    [_applyBtn setTitle:@"应用素材" forState:UIControlStateNormal];
    [_applyBtn setImage:[UIImage imageNamed:@"apply_icon"] forState:UIControlStateNormal];
    [bottomView addSubview:_applyBtn];
    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(bottomView);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-15);
    }];
    
    if (isRightData(_dataSource.designerId)) {
        _lookOverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookOverBtn.layer.cornerRadius = 20.f;
        _lookOverBtn.clipsToBounds = YES;
        _lookOverBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_lookOverBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_lookOverBtn setTitle:@"查看设计师" forState:UIControlStateNormal];
        [_lookOverBtn addEventHandler:^{
            DesignerMainPageVC *vc = [[DesignerMainPageVC alloc] init];
            vc.designerId = weakself.dataSource.designerId;
            [weakself.navigationController pushViewController:vc animated:YES];
        }];
        [bottomView addSubview:_lookOverBtn];
        [_lookOverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(bottomView);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(SCREEN_WIDTH - KFit_W(123) - 15 * 3);
        }];
        [_lookOverBtn.superview layoutIfNeeded];
        NSArray *colors= @[HEXColor(@"#FE7900", 1),HEXColor(@"#FF5100", 1)];
        UIImage *image = [UIImage imageWithGradientColor:colors andRect:_lookOverBtn.bounds andGradientType:1];
        [_lookOverBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        [_applyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(bottomView);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(KFit_W(123));
        }];
    }
    
    [_applyBtn.superview layoutIfNeeded];
    [_applyBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:2];
}

- (void)configData {
    [_imageView sd_setImageWithURL:ImgUrl_SD_OSS(_dataSource.logo, 180) placeholderImage:PlaceHolderImg];
    _nameLab.text = _dataSource.name;
    _priceLab.text = [NSString stringWithFormat:@"¥%@",_dataSource.price];
    _detailLab.text = _dataSource.detail;
    _isCollectImg.hidden = !_dataSource.isCollect;
}

- (void)videoTap {
    YBIBVideoData *data = [[YBIBVideoData alloc] init];
    data.videoURL = [NSURL URLWithString:self.dataSource.video];
    data.projectiveView = self.videoImg;
    
    YBImageBrowser *browser = [[YBImageBrowser alloc] init];
    browser.dataSourceArray = @[data];
    [browser show];
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
        weakself.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, weakself.webView.bottom + 20);
    }];
}

@end
