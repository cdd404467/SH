//
//  OrderChildsVC.m
//  SH
//
//  Created by i7colors on 2019/12/20.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderChildsVC.h"
#import "OrderListSectionHeader.h"
#import "OrderListSectionFooter.h"
#import "OrderListTBCell.h"
#import "NetTool.h"
#import "OrderModel.h"
#import <UIScrollView+EmptyDataSet.h>
#import "CddHud.h"
#import "Alert.h"
#import "PayTheOrderVC.h"
#import "PayModel.h"
#import "TimeAbout.h"
#import "OrderDetailVC.h"
#import "CheckTheExpressVC.h"

@interface OrderChildsVC()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<OrderModel *> *dataSource;
@end

@implementation OrderChildsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.leftBtn.hidden = YES;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestList];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStyleGrouped];
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

#pragma mark - 网络操作
//请求列表
- (void)requestList {
    NSString *urlString = [NSString stringWithFormat:URLGet_Order_List,_orderType,PageCount,self.pageNumber];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        NSArray *tempArr = [OrderModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        for (OrderModel *model in tempArr) {
            model.orderDataList = [OrderGoodsModel mj_objectArrayWithKeyValuesArray:model.orderDataList];
        }
        if (self.pageNumber == 1) {
            [self.dataSource removeAllObjects];
        }
        [self.dataSource addObjectsFromArray:tempArr];
        [self.tableView reloadData];
//        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    } Failure:^(NSError * _Nonnull error) {

    }];
}
//删除订单
- (void)deleteOrderWithSec:(NSInteger)section {
    NSDictionary *dict = @{@"id":[self.dataSource[section] orderID]
    };
    [CddHud show:[HelperTool getCurrentVC].view];
    [NetTool putRequest:URLPut_Order_Delete Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        [CddHud showTextOnly:@"删除成功" view:[HelperTool getCurrentVC].view];
        [self.dataSource removeObjectAtIndex:section];
        [self.tableView reloadData];
    } Error:^(id  _Nonnull json) {
        
    } Failure:^(NSError * _Nonnull error) {
    }];
}
//取消订单
- (void)cancelOrderWithSec:(NSInteger)section {
    NSDictionary *dict = @{@"id":[self.dataSource[section] orderID]
    };
    [CddHud show:[HelperTool getCurrentVC].view];
    [NetTool putRequest:URLPut_Order_Cancel Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        [CddHud showTextOnly:@"订单已取消" view:[HelperTool getCurrentVC].view];
        OrderModel *model = self.dataSource[section];
        model.orderStatus = 3;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
    } Error:^(id  _Nonnull json) {
        
    } Failure:^(NSError * _Nonnull error) {
    }];
}

//确认收货
- (void)confirmOrderWithSec:(NSInteger)section {
    NSDictionary *dict = @{@"id":[self.dataSource[section] orderID]
    };
    [CddHud show:[HelperTool getCurrentVC].view];
    [NetTool putRequest:URLPut_Order_Confirm Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        [CddHud showTextOnly:@"订单已确认收货" view:[HelperTool getCurrentVC].view];
        OrderModel *model = self.dataSource[section];
        model.orderStatus = 7; //变成已完成状态
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
    } Error:^(id  _Nonnull json) {
        
    } Failure:^(NSError * _Nonnull error) {
    }];
}

//查看物流
- (void)checkTheExpressVC:(NSInteger)section {
    CheckTheExpressVC *vc = [[CheckTheExpressVC alloc] init];
    vc.expressCode = [self.dataSource[section] expressCode];
    vc.expressNumber = [self.dataSource[section] expressNumber];
    [self.navigationController pushViewController:vc animated:YES];
}

//评价
- (void)evaluateOrderWithSec:(NSInteger)section {
    [CddHud showTextOnly:@"评价功能暂未开放哦～" view:self.view];
}

//获取订单号去付款
- (void)payWithOrderNum:(NSInteger)section {
    OrderModel *model = self.dataSource[section];
    NSDictionary *dict = @{@"orderNo":model.orderNo};
    [CddHud show:[HelperTool getCurrentVC].view];
    self.view.userInteractionEnabled = NO;
//    NSLog(@"pay ------ %@",dict);
    [NetTool postRequest:URLPost_OrderNo_Pay Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        self.view.userInteractionEnabled = YES;
        PayModel *payModel = [PayModel mj_objectWithKeyValues:json];
        PayTheOrderVC *vc = [[PayTheOrderVC alloc] init];
        vc.payInfo = payModel;
        vc.startDate = [TimeAbout stringToDateSec:model.orderTime];
        vc.totalMoney = model.orderAmount.stringValue;
        [self.navigationController pushViewController:vc animated:YES];
    } Error:^(id  _Nullable json) {
        self.view.userInteractionEnabled = YES;
    } Failure:^(NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
    }];
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
    return -100;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] orderDataList].count;
}
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OrderListSectionHeader *header = [OrderListSectionHeader headerWithTableView:tableView];
    header.model = self.dataSource[section];
    return header;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    OrderListSectionFooter *footer = [OrderListSectionFooter footerWithTableView:tableView];
    footer.section = section;
    OrderModel *model = self.dataSource[section];
    footer.model = model;
    DDWeakSelf;
    footer.leftBtnClickBlock = ^(NSInteger type, NSInteger section) {
        if (type == 3 || type == 7 || type == 8) {
            [Alert alertSystemTwo:@"是否确定删除此订单?" msg:nil cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
                [weakself deleteOrderWithSec:section];
            }];
        } else if (type == 1) {
            [Alert alertSystemTwo:@"是否确定取消此订单?" msg:nil cancelBtn:@"放弃" okBtn:@"确定" OKCallBack:^{
                [weakself cancelOrderWithSec:section];
            }];
        } else if (type == 4) {
            [self checkTheExpressVC:section];
        }
    };
    footer.rightBtnClickBlock = ^(NSInteger type, NSInteger section) {
        if (type == 1) {
            [self payWithOrderNum:section];
        } else if (type == 4) {
            [Alert alertSystemTwo:@"是否确认收货?" msg:nil cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
                [self confirmOrderWithSec:section];
            }];
        } else if (type == 6) {
            [self evaluateOrderWithSec:section];
        }
    };
    footer.detailClickBlock = ^(NSInteger section) {
        OrderDetailVC *vc = [[OrderDetailVC alloc] init];
        vc.orderID = model.orderID;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return footer;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTBCell *cell = [OrderListTBCell cellWithTableView:tableView];
    OrderModel *model = self.dataSource[indexPath.section];
    cell.model = model.orderDataList[indexPath.row];
    return cell;
}

@end
