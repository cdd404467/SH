//
//  SearchView.m
//  SH
//
//  Created by i7colors on 2019/9/17.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SearchView.h"

@interface SearchView()<UITextFieldDelegate>

@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UITextField *searchTF = [[UITextField alloc] init];
    searchTF.backgroundColor = HEXColor(@"#F6F6F6", 1);
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.layer.cornerRadius = 15;
    searchTF.tintColor = MainColor;
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.enablesReturnKeyAutomatically = YES;
    searchTF.font = [UIFont systemFontOfSize:14];
    searchTF.delegate = self;
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
    leftImg.frame = CGRectMake(9, 0, 16, 16);
    leftImg.contentMode = UIViewContentModeScaleAspectFit;
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 30, 16);
    [leftView addSubview:leftImg];
    searchTF.leftView = leftView;
    [self addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-62);
    }];
    _searchTF = searchTF;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HEXColor(@"#9B9B9B", 1) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.height.mas_equalTo(searchTF);
        make.width.mas_equalTo(40);
    }];
    _cancelBtn = cancelBtn;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        if (self.searchBlock) {
            self.searchBlock();
        }
    }
    return YES;
}

- (void)cancelClick {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
