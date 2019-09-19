//
//  GoodsDetailsSectionHeader.m
//  SH
//
//  Created by i7colors on 2019/9/19.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "GoodsDetailsSectionHeader.h"

@interface GoodsDetailsSectionHeader()
@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView *line;
@end

@implementation GoodsDetailsSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    
    //红色view
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = HEXColor(@"#FF5100", 1);
    [bgView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(bgView);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(13);
    }];
    
    //标题
    UILabel *titleName = [[UILabel alloc] init];
    titleName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleName.textColor = HEXColor(@"#090203", 1);
    [bgView addSubview:titleName];
    [titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftView.mas_right).offset(8);
        make.centerY.mas_equalTo(leftView);
        make.right.mas_equalTo(bgView.mas_centerX).offset(50);
        make.height.mas_equalTo(25);
    }];
    _titleName = titleName;
    
    //更多按钮
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [moreBtn setTitleColor:HEXColor(@"#4A4A4A", 1) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    moreBtn.adjustsImageWhenHighlighted = NO;
    [moreBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(titleName);
    }];
    _moreBtn = moreBtn;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"#D6D6D6", 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    _line = line;
}

- (void)btnClick {
    if (self.clickMoreBlock) {
        self.clickMoreBlock();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleName.text = title;
}

- (void)setShowMoreBtn:(BOOL)showMoreBtn {
    _moreBtn.hidden = !showMoreBtn;
}

- (void)setShowLine:(BOOL)showLine {
    _line.hidden = !showLine;
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"GoodsDetailsSectionHeader";
    // 1.缓存中取
    GoodsDetailsSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[GoodsDetailsSectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}
@end
