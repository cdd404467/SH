//
//  MinePageHeader.m
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MinePageHeader.h"
#import "UIButton+Extension.h"

static const CGFloat iconWidth = 55.f;

@interface MinePageHeader()
//昵称
@property (nonatomic, strong) UILabel *nickNameLab;
//我的订单
@property (nonatomic, strong) UIButton *myOrderBtn;
//退款/售后
@property (nonatomic, strong) UIButton *afterSaleBtn;
//团队订单
@property (nonatomic, strong) UIButton *teamOrderBtn;
//砍价订单
@property (nonatomic, strong) UIButton *bargainOrderBtn;
@end

@implementation MinePageHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *infoBgView = [[UIView alloc] init];
    infoBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    //设置图片背景
    UIImage *image = [UIImage imageNamed:@"topBg"];
    infoBgView.layer.contents = (id) image.CGImage;
    [self addSubview:infoBgView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 25, 64, 64)];
    headerImageView.backgroundColor = UIColor.blackColor;
    [HelperTool drawRound:headerImageView borderWidth:2.f borderColor:UIColor.whiteColor];
    [self addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    UILabel *nickNameLab = [[UILabel alloc] init];
    nickNameLab.text = @"一叶知秋";
    nickNameLab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    nickNameLab.textColor = UIColor.whiteColor;
    [self addSubview:nickNameLab];
    [nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right).offset(15);
        make.top.mas_equalTo(headerImageView);
        make.height.mas_equalTo(28);
        make.right.mas_equalTo(-10);
    }];
    
    
    //下半部分订单view
    UIView *botView = [[UIView alloc] init];
    botView.frame = CGRectMake(0, 110, SCREEN_WIDTH, 80);
    botView.backgroundColor = UIColor.whiteColor;
    [HelperTool drawRound:botView corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:10.f];
    [self addSubview:botView];
    
    
    CGFloat leftGap = 23;
    CGFloat btnGap = (SCREEN_WIDTH - leftGap * 2 - iconWidth * 4) / 3;
    
    //创建4个icon
    NSArray<NSString*> *titleArr = @[@"我的订单",@"退款/售后",@"团队订单",@"砍价订单"];
    NSArray<NSString *> *imgArr = @[@"icon_myOrder",@"icon_afterSale",@"icon_teamOrder",@"icon_bargain"];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftGap + (btnGap + iconWidth) * i, 14, iconWidth, iconWidth);
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:HEXColor(@"#090203", 1) forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:9];

        [botView addSubview:btn];
        if (i == 0) {
            _myOrderBtn = btn;
        } else if (i == 1) {
            _afterSaleBtn = btn;
        } else if (i == 2) {
            _teamOrderBtn = btn;
        } else {
            _bargainOrderBtn = btn;
        }
    }
}

@end
