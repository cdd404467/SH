//
//  PaySuccessVC.m
//  SH
//
//  Created by i7colors on 2019/12/21.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "PaySuccessVC.h"
#import "OrderStatusView.h"
#import "OrderGoodsTBCell.h"

@interface PaySuccessVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OrderStatusView *headerView;
@end

@implementation PaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"支付成功";
    [self.view addSubview:self.tableView];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = RGBA(232, 232, 232, 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _headerView = [[OrderStatusView alloc] init];
        _headerView.imageName = @"order_status_success";
        _headerView.title = @"支付成功";
        _tableView.tableHeaderView = _headerView;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return _tableView;
}

#pragma mark - tableView delegate
//几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

//自定义的section header
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    ConfirmOrderSectionHeader *header = [ConfirmOrderSectionHeader headerWithTableView:tableView];
//    ConfirmOrderModel *model = self.dataSource[section];
//    header.title = model.shopName;
//    return header;
//}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderGoodsTBCell *cell = [OrderGoodsTBCell cellWithTableView:tableView];
    
    return cell;
}

@end


