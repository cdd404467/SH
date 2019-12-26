//
//  TempVC.m
//  SH
//
//  Created by i7colors on 2019/12/24.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "TempVC.h"
#import <UIScrollView+EmptyDataSet.h>
#import "CddHud.h"

@interface TempVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TempVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 1) {
        self.navBar.title = @"退款/售后";
    } else if (_type == 2) {
        self.navBar.title = @"团队订单";
    } else if (_type == 3) {
        self.navBar.title = @"砍价订单";
    }
    self.navBar.bottomLine.hidden = NO;
    int x = arc4random() % 3 + 1;
    float a = x / 2.0;
    [CddHud show:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(a * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CddHud hideHUD:self.view];
        [self.view addSubview:self.tableView];
    });
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif + 20, 0);
    }
    return _tableView;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_order"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无相关订单";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#999999", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return UIColor.whiteColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -80;
}


#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}
@end
