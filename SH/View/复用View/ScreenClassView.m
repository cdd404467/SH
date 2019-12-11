//
//  ScreenClassView.m
//  SH
//
//  Created by i7colors on 2019/11/22.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ScreenClassView.h"
#import "UIButton+Extension.h"

@interface ScreenClassView()
//综合
@property (nonatomic, strong) UIButton *synthesizeBtn;
//销量
@property (nonatomic, strong) UIButton *saleBtn;
//价格
@property (nonatomic, strong) UIButton *priceBtn;
//选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;
//
@property (nonatomic, assign) NSInteger priceOrder;
@end

@implementation ScreenClassView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.priceOrder = 3;
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    NSArray *titleArr = @[@"综合",@"销量",@"价格"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXColor(@"#9B9B9B", 1) forState:UIControlStateNormal];
        [button setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [button addTarget:self action:@selector(selectClassify:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 1001;
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.mas_equalTo(55);
            } else if (i == 1) {
                make.centerX.mas_equalTo(self);
            } else {
                make.right.mas_equalTo(-55);
            }
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(50);
        }];
        
        if (i == 0) {
            self.synthesizeBtn = button;
            self.synthesizeBtn.selected = YES;
            self.selectedBtn = self.synthesizeBtn;
        } else if (i == 1) {
            self.saleBtn = button;
        } else {
            self.priceBtn = button;
            [self.priceBtn setImage:[UIImage imageNamed:@"price_unSelected"] forState:UIControlStateNormal];
            [self.priceBtn.superview layoutIfNeeded];
            [self.priceBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:3];
        }
    }
}

- (void)selectClassify:(UIButton *)sender {
    sender.highlighted = NO;
    NSInteger tag = sender.tag - 1000;
    if (tag != 3) {
        if (sender != self.selectedBtn ) {
            _priceOrder = 3;
            self.selectedBtn.selected = NO;
            sender.selected = YES;
            self.selectedBtn = sender;
            if (self.btnClickBlock) {
                self.btnClickBlock(tag);
            }
        }
    }
    //如果是3,就是价格，有升序和降序
    else {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        if (_priceOrder == 3) {
            [self.priceBtn setImage:[UIImage imageNamed:@"price_down"] forState:UIControlStateSelected];
        } else {
            [self.priceBtn setImage:[UIImage imageNamed:@"price_up"] forState:UIControlStateSelected];
        }
        if (self.btnClickBlock) {
            self.btnClickBlock(_priceOrder);
        }
        _priceOrder = _priceOrder == 3 ? 4 : 3;
    }
}

@end
