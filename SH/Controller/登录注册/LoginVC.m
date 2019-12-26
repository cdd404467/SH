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
#import "CountDown.h"
#import "CddHud.h"

@interface LoginVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation LoginVC

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [super useImgMode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"登录/注册";
    [self.navBar.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navBar.backMode = 1;
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
    if (![self checkPhone])
        return;
    NSString *urlString = [NSString stringWithFormat:URLGet_SMS_Code,_phoneTF.text];
    [self.codeBtn setTitle:nil forState:UIControlStateNormal];
    [self.activityIndicator startAnimating];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        [self.activityIndicator stopAnimating];
        [self countDown:self.codeBtn];
        
    } Failure:^(NSError * _Nonnull error) {
        self.codeBtn.enabled = YES;
    }];
}

- (void)login {
    if (![self checkPhone])
        return;
    if (![self checkCode])
        return;
    [self.view endEditing:YES];
    
    NSDictionary *dict = @{@"mobile":_phoneTF.text,
                           @"verifyCode":_codeTF.text
    };
    
    [CddHud showWithText:@"登录中..." view:self.view];
    self.loginBtn.enabled = NO;
    [NetTool postRequest:URLPost_Login_Register Params:dict Success:^(id  _Nonnull json) {
        self.loginBtn.enabled = YES;
        [CddHud hideHUD:self.view];
        //登录成功回调
        if (self.loginCompleteBlock) {
            self.loginCompleteBlock();
        }
        //转字典
//        NSLog(@"--- %@",json);
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [mDict setValue:json[@"token"] forKey:@"token"];
        if (isRightData(To_String(json[@"user"][@"nickname"]))) {
            [mDict setValue:json[@"user"][@"nickname"] forKey:@"nickname"];
        } else {
            [mDict setValue:json[@"user"][@"mobile"] forKey:@"nickname"];
        }
        if (isRightData(To_String(json[@"user"][@"headimgurl"]))) {
            [mDict setValue:json[@"user"][@"headimgurl"] forKey:@"headimgurl"];
        }
        [mDict setValue:json[@"user"][@"mobile"] forKey:@"mobile"];
        [UserDefault setObject:[mDict copy] forKey:@"userInfo"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_UserLoginSuccess object:nil userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } Error:^(id  _Nullable json) {
        self.loginBtn.enabled = YES;
    } Failure:^(NSError * _Nonnull error) {
        self.loginBtn.enabled = YES;
        [CddHud hideHUD:self.view];
    }];
}


- (BOOL)checkPhone {
    if (_phoneTF.text.length == 0) {
        [CddHud showTextOnly:@"请填写手机号" view:self.view];
        return NO;
    } else if (_phoneTF.text.length < 11) {
        [CddHud showTextOnly:@"请填写正确的手机号" view:self.view];
        return NO;
    } else if (_phoneTF.text.length > 1 && [_phoneTF.text substringToIndex:1].intValue != 1) {
        [CddHud showTextOnly:@"请填写正确的手机号" view:self.view];
        return NO;
    }
    return YES;
}

- (BOOL)checkCode {
    if (_codeTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入验证码" view:self.view];
        return NO;
    } else if (_codeTF.text.length < 4) {
        [CddHud showTextOnly:@"请输入正确的验证码" view:self.view];
        return NO;
    }
    return YES;
}

#pragma mark 倒计时
-(void)countDown:(UIButton *)sender {
    //    60s的倒计时
     DDWeakSelf;
       //    60s的倒计时
   NSTimeInterval aMinutes = 30;
   NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:aMinutes];
   
   CountDown *countDown = [[CountDown alloc] init];
   [countDown countDownWithStratDate:[NSDate date] finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
       //        NSLog(@"second = %li",second);
       NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
       if (totoalSecond == 0) {
           [self.activityIndicator stopAnimating];
           weakself.codeBtn.enabled = YES;
           [weakself.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
       }else{
           weakself.codeBtn.enabled = NO;
           [weakself.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)totoalSecond] forState:UIControlStateNormal];
       }
   }];
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
        make.centerY.mas_equalTo(phoneLab);
        make.height.mas_equalTo(34);
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
    
    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.font = [UIFont systemFontOfSize:15];
    codeTF.placeholder = @"输入验证码";
    codeTF.tintColor = MainColor;
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.maxLength = 4;
    [self.scrollView addSubview:codeTF];
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeLab.mas_right).offset(22);
        make.centerY.mas_equalTo(codeLab);
        make.right.mas_equalTo(codeBtn.mas_left).offset(-5);
        make.height.mas_equalTo(phoneTF);
    }];
    _codeTF = codeTF;
    
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = line_1.backgroundColor;
    [self.scrollView addSubview:line_2];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(line_1);
        make.top.mas_equalTo(codeLab.mas_bottom).offset(12);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
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
    _loginBtn = loginBtn;
    
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + Bottom_Height_Dif);
    [codeBtn.superview layoutIfNeeded];
    [loginBtn setBackgroundImage:[HelperTool globalGradientColor:loginBtn.bounds] forState:UIControlStateNormal];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    [codeBtn addSubview:self.activityIndicator];
    //设置小菊花颜色
    self.activityIndicator.color = UIColor.grayColor;
    //设置背景颜色
    self.activityIndicator.backgroundColor = UIColor.clearColor;
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.center.mas_equalTo(codeBtn);
    }];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
