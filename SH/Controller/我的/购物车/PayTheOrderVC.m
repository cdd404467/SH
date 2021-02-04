//
//  PayTheOrderVC.m
//  SH
//
//  Created by i7colors on 2019/12/26.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "PayTheOrderVC.h"
#import "WXApiManager.h"
#import "PayModel.h"
#import "CountDown.h"
#import "BEMCheckBox.h"
#import "MyOrdersVC.h"
#import "NetTool.h"
#import "CddHud.h"
#import "OrderModel.h"


@interface PayTheOrderVC ()<BEMCheckBoxDelegate>
@property (nonatomic, strong) UILabel *totalMoneyLab;
@property (nonatomic, strong) UILabel *timeRemainLab;
@property (nonatomic, strong) CountDown *countDownTimer;
@property (nonatomic, strong) BEMCheckBoxGroup *boxGroup;
@property (nonatomic, strong) BEMCheckBox *weixinBox;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) OrderDetailModel *statusModel;
@property (nonatomic, assign) BOOL isGoToPay;
@end

@implementation PayTheOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isGoToPay = NO;
    self.view.backgroundColor = HEXColor(@"#f6f6f6", 1);
    self.navBar.title = @"支付订单";
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPayState) name:NotificationName_ApplicationDidBecomeActive object:nil];
    [self.navBar.leftBtn addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)backEvent {
    if (self.orderChangeBlock) {
        self.orderChangeBlock();
    }
}

//检查支付状态
- (void)checkPayState {
    if (!self.isGoToPay) {
        return;
    }
    [self backEvent];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateInfo {
    _totalMoneyLab.text = [NSString stringWithFormat:@"¥%@",_totalMoney];
    [self dealTime];
}

- (void)dealTime {
    NSDate *now = [NSDate date];
    NSTimeInterval hour = 1 * 60 * 60;
    NSDate *endDate = [_startDate dateByAddingTimeInterval:hour];
    DDWeakSelf;
    _countDownTimer = [[CountDown alloc] init];
    [_countDownTimer countDownWithStratDate:now finishDate:endDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSString *minStr = [NSString string];
        NSString *secStr = [NSString string];
        if (minute < 10) {
            minStr = [NSString stringWithFormat:@"0%ld",(long)minute];
        }else {
            minStr = [NSString stringWithFormat:@"%ld",(long)minute];
        }
        if (second < 10) {
            secStr = [NSString stringWithFormat:@"0%ld",(long)second];
        }else {
            secStr = [NSString stringWithFormat:@"%ld",(long)second];
        }
        weakself.timeRemainLab.text = [NSString stringWithFormat:@"支付剩余时间: %@ : %@",minStr,secStr];
    }];
}

- (void)weixinPay {
    self.isGoToPay = YES;
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = _payInfo.pay.partnerid;
    req.prepayId = _payInfo.pay.prepayid;
    req.nonceStr = _payInfo.pay.noncestr;
    req.timeStamp = _payInfo.pay.timestamp;
    req.package = _payInfo.pay.package;
    req.sign = _payInfo.pay.signNew;
    
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:WeixinPayResultSuccess object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:WeixinPayResultFailed object:nil];
        }
    }];
}

- (void)setupUI {
    UIView *topBg = [[UIView alloc] init];
    topBg.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 150);
    topBg.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topBg];
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"订单金额";
    txtLab.font = [UIFont systemFontOfSize:15];
    txtLab.textColor = HEXColor(@"#4A4A4A", 1);
    [topBg addSubview:txtLab];
    [txtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(21);
    }];
    
    _totalMoneyLab = [[UILabel alloc] init];
    _totalMoneyLab.font = [UIFont systemFontOfSize:30];
    _totalMoneyLab.textColor = HEXColor(@"#4A4A4A", 1);
    [topBg addSubview:_totalMoneyLab];
    [_totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(45);
        make.height.mas_equalTo(56);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = Line_Color;
    [topBg addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
        make.top.mas_equalTo(self.totalMoneyLab.mas_bottom).offset(6);
    }];
    
    _timeRemainLab = [[UILabel alloc] init];
    _timeRemainLab.textAlignment = NSTextAlignmentCenter;
    _timeRemainLab.font = [UIFont systemFontOfSize:15];
    _timeRemainLab.textColor = HEXColor(@"#9B9B9B", 1);
    [topBg addSubview:_timeRemainLab];
    [_timeRemainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-12);
    }];
    
    //支付方式
    NSArray *payTypeArr = @[@"微信支付"];
    CGFloat height = 50.f;
    for (NSInteger i = 0; i < payTypeArr.count; i ++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topBg.mas_bottom).offset(8 + i * height);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(height);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pay_weixin"];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(18);
            make.centerY.mas_equalTo(view);
        }];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = payTypeArr[i];
        nameLab.textColor = HEXColor(@"#4A4A4A", 1);
        nameLab.font = [UIFont systemFontOfSize:14];
        [view addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(5);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(view);
            make.right.mas_lessThanOrEqualTo(-40);
        }];
        
        BEMCheckBox *checkBox = [[BEMCheckBox alloc] init];
        checkBox.delegate = self;
        checkBox.boxType = BEMBoxTypeCircle;
        checkBox.lineWidth = 1.f;
        checkBox.frame = CGRectMake(SCREEN_WIDTH - 15 - 20, 15, 20, 20);
        checkBox.onTintColor = HEXColor(@"#FF5100", 1);
        checkBox.onFillColor = HEXColor(@"#FF5100", 1);
        checkBox.onCheckColor = UIColor.whiteColor;
        checkBox.onAnimationType = BEMAnimationTypeFade;
        checkBox.offAnimationType = BEMAnimationTypeFade;
        [view addSubview:checkBox];
        
        _weixinBox = checkBox;
    }
        
        //按钮组
        self.boxGroup = [[BEMCheckBoxGroup alloc] init];
        [self.boxGroup addCheckBoxToGroup:_weixinBox];
    //    [self.boxGroup addCheckBoxToGroup:_disAgreeZTC];
//        self.boxGroup.selectedCheckBox = self._weixinBox;
        self.boxGroup.mustHaveSelection = YES;
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.layer.cornerRadius = 20.f;
    _payBtn.clipsToBounds = YES;
    _payBtn.adjustsImageWhenHighlighted = false;
    [_payBtn addTarget:self action:@selector(weixinPay) forControlEvents:UIControlEventTouchUpInside];
    [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-Bottom_Height_Dif - 8);
    }];
    [_payBtn.superview layoutIfNeeded];
    [_payBtn setBackgroundImage:[HelperTool globalGradientColor:_payBtn.bounds] forState:UIControlStateNormal];
    
    [self updateInfo];
}

- (void)paySuccess {
    NSLog(@"成功---");
}

- (void)payFail {
    NSLog(@"失败---");
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

