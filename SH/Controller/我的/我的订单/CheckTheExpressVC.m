//
//  CheckTheExpressVC.m
//  SH
//
//  Created by i7colors on 2020/1/3.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "CheckTheExpressVC.h"
#import "NetTool.h"
#import "ExpressTBCell.h"
#import "ExpressModel.h"

@interface CheckTheExpressVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<ExpressModel *> *dataSource;
@end

@implementation CheckTheExpressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"查看物流";
    self.navBar.backgroundColor = Like_Color;
    [self requestData];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        header.backgroundColor = UIColor.whiteColor;
        _tableView.tableHeaderView = header;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    }
    return _tableView;
}

#pragma mark - 网络操作
//请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Order_Express,_expressCode,_expressNumber];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [ExpressModel mj_objectArrayWithKeyValuesArray:json[@"Traces"]];
        [self.view addSubview:self.tableView];
    } Failure:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource[indexPath.row] cellHeight];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpressTBCell *cell = [ExpressTBCell cellWithTableView:tableView];
    cell.index = indexPath.row;
    cell.isLineHidden = self.dataSource.count - 1 == indexPath.row ? YES : NO;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

@end
