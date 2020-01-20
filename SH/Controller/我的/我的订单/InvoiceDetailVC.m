//
//  InvoiceDetailVC.m
//  SH
//
//  Created by i7colors on 2020/1/2.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "InvoiceDetailVC.h"
#import "InvoiceDetailTBCell.h"
#import "NetTool.h"

@interface InvoiceDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InvoiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"发票详情";
    [self.view addSubview:self.tableView];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return _tableView;
}


#pragma mark - tableView delegate
//几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.leftArray.count;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.leftArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = HEXColor(@"#9B9B9B", 1);
    lab.font = [UIFont systemFontOfSize:14];
    lab.frame = CGRectMake(15, 20, 200, 20);
    lab.backgroundColor = UIColor.clearColor;
    [view addSubview:lab];
    if (section == 1) {
        lab.text = @"公司信息";
        return view;
    } else if (section == 2) {
        lab.text = @"收票人信息";
        return view;
    }
    return [UIView new];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvoiceDetailTBCell *cell = [InvoiceDetailTBCell cellWithTableView:tableView];
    cell.leftLab.text = self.leftArray[indexPath.section][indexPath.row];
    cell.rightLab.text = self.rightArray[indexPath.section][indexPath.row];
    return cell;
}

@end
