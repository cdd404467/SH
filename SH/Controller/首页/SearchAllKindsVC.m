//
//  SearchAllKindsVC.m
//  SH
//
//  Created by i7colors on 2019/9/17.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SearchAllKindsVC.h"
#import "SearchView.h"
#import "AppointKindSearchVC.h"

@interface SearchAllKindsVC ()
@property (nonatomic, strong) SearchView *searchView;
@end

@implementation SearchAllKindsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self setupUI];
    
    
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, STATEBAR_HEIGHT, SCREEN_WIDTH - 50, 44);
//    view.backgroundColor = UIColor.redColor;
//    [self.navigationItem.titleView sizeToFit];
//    self.navigationItem.titleView = view;
//    self.backBtn.backgroundColor = UIColor.redColor;
//    self.backBtn.backgroundColor = UIColor.redColor;
//
//    [self vhl_setNavBarHidden:YES];
    
}

- (void)setupUI {
    SearchView *searchView = [[SearchView alloc] init];
    searchView.top = NAV_HEIGHT;
    searchView.searchTF.placeholder = @"搜索";
    [searchView.searchTF becomeFirstResponder];
    DDWeakSelf;
    searchView.cancelBlock = ^{
        [weakself popBack];
    };
//    searchView.searchBlock = ^{
//        [weakself requestData];
//    };
    [self.view addSubview:searchView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = HEXColor(@"#D6D6D6", 1);
    tipLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    tipLabel.text = @"搜索指定内容";
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(searchView.mas_bottom).offset(24);
        make.height.mas_equalTo(26);
    }];
    
    NSArray *titleArr = @[@"商品",@"场景",@"店铺",@"设计师",@"素材"];
    NSMutableArray *btnArr = [NSMutableArray arrayWithCapacity:0];
    CGFloat gap = 37.f;
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i + 101;
        [button setTitleColor:HEXColor(@"#4A4A4A", 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(searchKindsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(30);
        }];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [btnArr addObject:button];
        
        [(UIButton *)btnArr[i] mas_updateConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.mas_equalTo(40);
            } else {
                UIButton *btn = btnArr[i - 1];
                make.left.mas_equalTo(btn.mas_right).offset(gap);
            }
        }];
    }
    
    UIButton *centerBtn = (UIButton *)btnArr[2];
    [centerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(-7);
    }];

    UIButton *firstBtn = (UIButton *)btnArr[0];
    UIButton *secondBtn = (UIButton *)btnArr[1];
    [firstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(secondBtn.mas_left).offset(-gap);
        make.centerY.height.mas_equalTo(secondBtn);
    }];
    [firstBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //中间的分割线
    for (NSInteger i = 1; i < btnArr.count; i++) {
        UIView *spLine = [[UIView alloc] init];
        spLine.backgroundColor = HEXColor(@"#D6D6D6", 1);
        [self.view addSubview:spLine];
        UIButton *btn = btnArr[i - 1];
        [spLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn.mas_right).offset((gap - 1) * 0.5);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(1);
            make.centerY.mas_equalTo(btn);
        }];
    }
}



- (void)searchKindsClick:(UIButton *)sender {
    [self.view endEditing:YES];
    AppointKindSearchVC *vc = [[AppointKindSearchVC alloc] init];
    vc.title = [NSString stringWithFormat:@"搜索%@",sender.titleLabel.text];
    vc.type = sender.tag - 100;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)popBack {
    [self.view endEditing:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
