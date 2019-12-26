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
#import "SearchAllKindsResultsVC.h"

@interface SearchAllKindsVC ()
@property (nonatomic, strong) SearchView *searchView;
@end

@implementation SearchAllKindsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"搜索";
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)jumpToResult {
    [self.view endEditing:YES];
    SearchAllKindsResultsVC *vc = [[SearchAllKindsResultsVC alloc] init];
    vc.keyWords = self.searchView.searchTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI {
    SearchView *searchView = [[SearchView alloc] init];
    searchView.top = NAV_HEIGHT;
    searchView.searchTF.enablesReturnKeyAutomatically = YES;
    searchView.searchTF.placeholder = @"搜索";
    DDWeakSelf;
    searchView.cancelBlock = ^{
        [weakself popBack];
    };
    searchView.searchBlock = ^{
        [weakself jumpToResult];
    };
    _searchView = searchView;
    [self.view addSubview:searchView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchView.searchTF becomeFirstResponder];
    });
    
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
    
//    NSArray *titleArr = @[@"商品",@"场景",@"店铺",@"设计师",@"素材"];
    NSArray *titleArr = @[@"商品",@"场景",@"设计师",@"素材"];
    NSMutableArray *btnArr = [NSMutableArray arrayWithCapacity:0];
    CGFloat gap = 37.f;
    CGFloat allBtnWidth = 0;
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i < 2) {
            button.tag = i + 101;
        } else {
            button.tag = i + 102;
        }
        
        [button setTitleColor:HEXColor(@"#4A4A4A", 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(searchKindsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(30);
        }];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [btnArr addObject:button];
        [button.superview layoutIfNeeded];
        allBtnWidth += button.width;
    }
    
    CGFloat leftGap = (SCREEN_WIDTH - allBtnWidth - gap * (titleArr.count - 1)) / 2;
    CGFloat lastWith = leftGap;
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *btn = (UIButton *)btnArr[i];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastWith);
        }];
        lastWith += btn.width + gap;
    }
    
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
