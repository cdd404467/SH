//
//  LoginVC.m
//  SH
//
//  Created by i7colors on 2019/9/4.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "LoginVC.h"
#import "UITextField+Limit.h"
#import "NetTool.h"

@interface LoginVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@end

@implementation LoginVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [super useImgMode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 500);
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (void)getSMSCode {
//    [NetTool test];
}


- (void)setupUI {
    [self.view addSubview:self.scrollView];
    UIImageView *appHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon"]];
    [self.scrollView addSubview:appHeader];
    [appHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView).offset(50);
        make.width.height.mas_equalTo(80);
        make.centerX.mas_equalTo(self.scrollView);
    }];
    
    //手机号
    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.text = @"手机号";
    phoneLab.textColor = HEXColor(@"#090203", 1);
    phoneLab.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(appHeader.mas_bottom).offset(66);
        make.height.mas_equalTo(21);
    }];
    [phoneLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.font = [UIFont systemFontOfSize:15];
    phoneTF.placeholder = @"输入手机号";
    phoneTF.tintColor = MainColor;
    phoneTF.maxLength = 11;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLab.mas_right).offset(22);
        make.height.top.mas_equalTo(phoneLab);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
    }];
    _phoneTF = phoneTF;
    
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = HEXColor(@"#D9D5CC", 1);
    [self.scrollView addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLab);
        make.right.mas_equalTo(phoneTF);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(phoneLab.mas_bottom).offset(12);
    }];
    
    //验证码
    UILabel *codeLab = [[UILabel alloc] init];
    codeLab.text = @"验证码";
    codeLab.textColor = phoneLab.textColor;
    codeLab.font = phoneLab.font;
    [self.scrollView addSubview:codeLab];
    [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(phoneLab);
        make.top.mas_equalTo(line_1.mas_bottom).offset(12);
        
    }];
    [codeLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.font = [UIFont systemFontOfSize:15];
    codeTF.placeholder = @"输入验证码";
    codeTF.tintColor = MainColor;
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.maxLength = 6;
    [self.scrollView addSubview:codeTF];
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeLab.mas_right).offset(22);
        make.height.top.mas_equalTo(codeLab);
        make.right.mas_equalTo(phoneTF.mas_centerX).offset(0);
    }];
    _codeTF = codeTF;
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.backgroundColor = UIColor.clearColor;
    [codeBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [codeBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(codeLab);
        make.right.mas_equalTo(line_1);
    }];
    [codeBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _codeBtn = codeBtn;
    
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = line_1.backgroundColor;
    [self.scrollView addSubview:line_2];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(line_1);
        make.top.mas_equalTo(codeLab.mas_bottom).offset(12);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.layer.cornerRadius = 22;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.scrollView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(line_1);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(line_2.mas_bottom).offset(40);
    }];
    
    [HelperTool addLayerHorizontal:loginBtn startColor:HEXColor(@"#FE7900", 1) endColor:HEXColor(@"#FF5100", 1)];
    
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + Bottom_Height_Dif);
}


@end
