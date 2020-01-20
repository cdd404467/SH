//
//  OrderDetailVC.m
//  SH
//
//  Created by i7colors on 2019/12/27.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderStatusView.h"
#import "NetTool.h"
#import "OrderModel.h"
#import "OrderGoodsTBCell.h"
#import "AddressDisplayTBCell.h"
#import "OrderDetailInfoTBCell.h"
#import "CddHud.h"
#import "InvoiceDetailVC.h"
#import "CheckTheExpressVC.h"
#import "PayModel.h"
#import "PayTheOrderVC.h"
#import "TimeAbout.h"


@interface OrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OrderStatusView *headerView;
@property (nonatomic, strong) OrderDetailModel *dataSource;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *timeTxtArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *invoiceLeftArray;
@property (nonatomic, strong) NSMutableArray *invoiceRightArray;
@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"订单详情";
    [self requestData];
}

- (OrderStatusView *)headerView {
    if (!_headerView) {
        _headerView = [[OrderStatusView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)timeArray {
    if (!_timeArray) {
        _timeArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _timeArray;
}

- (NSMutableArray *)timeTxtArray {
    if (!_timeTxtArray) {
        _timeTxtArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _timeTxtArray;
}

- (NSMutableArray *)invoiceLeftArray {
    if (!_invoiceLeftArray) {
        _invoiceLeftArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _invoiceLeftArray;
}

- (NSMutableArray *)invoiceRightArray {
    if (!_invoiceRightArray) {
        _invoiceRightArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _invoiceRightArray;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
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
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

#pragma mark - 网络操作
//请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Order_Detail,_orderID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [OrderDetailModel mj_objectWithKeyValues:json];
        self.dataSource.orderDataList = [OrderGoodsModel mj_objectArrayWithKeyValuesArray:self.dataSource.orderDataList];
        [self dealDatasource];
        [self setupUI];
        [self.view addSubview:self.tableView];
        [self setBtnStateWithStatus:self.dataSource.orderStatus];
        self.headerView.status = self.dataSource.orderStatus;
        if (self.dataSource.isInvoice == 1) {
            [self invoiceDataSource];
        }
    } Failure:^(NSError * _Nonnull error) {
    }];
}

- (void)dealDatasource {
    [self.timeArray addObject:@" "];
    [self.timeTxtArray addObject:[NSString stringWithFormat:@"订单编号: %@",self.dataSource.orderNo]];
    if (isRightData(self.dataSource.orderTime)) {
        [self.timeArray addObject:self.dataSource.orderTime];
        [self.timeTxtArray addObject:@"下单时间"];
    }
    if (isRightData(self.dataSource.deliverAt)) {
        [self.timeArray addObject:self.dataSource.deliverAt];
        [self.timeTxtArray addObject:@"发货时间"];
    }
    if (isRightData(self.dataSource.confirmAt)) {
        [self.timeArray addObject:self.dataSource.confirmAt];
        [self.timeTxtArray addObject:@"收货时间"];
    }
    if (isRightData(self.dataSource.evaluateAt)) {
        [self.timeArray addObject:self.dataSource.evaluateAt];
        [self.timeTxtArray addObject:@"评价时间"];
    }
}

//发票数据
- (void)invoiceDataSource {
    NSArray *mArr_1 = @[_dataSource.invoiceType == 1 ? @"普通发票(电子)" : @"增值税专用发票",
                        _dataSource.normalType == 1 ? @"个人" : @"企业",
                        _dataSource.invoiceTitle,
                        _dataSource.invoiceContent];
    
    [self.invoiceLeftArray addObject:@[@"发票类型",@"发票性质",@"发票抬头",@"发票内容"]];
    [self.invoiceRightArray addObject:mArr_1];
    
    if (_dataSource.invoiceType == 2) {
        NSArray *mArr_2 = @[_dataSource.invoiceEnterpriseName,
                            _dataSource.invoiceTaxCode,
                            _dataSource.invoiceLoginAddress,
                            _dataSource.invoiceMobile,
                            _dataSource.invoiceBankName,
                            _dataSource.invoiceAccount,];
        [self.invoiceLeftArray addObject:@[@"单位名称",@"纳税人识别码",@"注册地址",@"注册电话",@"开户银行",@"银行账户"]];
        [self.invoiceRightArray addObject:mArr_2];
        
        NSArray *mArr_3 = @[_dataSource.invoiceNickname,
                            _dataSource.invoiceAddress];
        [self.invoiceLeftArray addObject:@[@"昵称",@"地址"]];
        [self.invoiceRightArray addObject:mArr_3];
    }
}

- (void)setupUI {
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_bottomView];
     [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
    }];
     
     _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [_rightBtn setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateNormal];
     _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
     _rightBtn.layer.cornerRadius = 14.f;
     _rightBtn.layer.borderColor = HEXColor(@"#FF5100", 1).CGColor;
     _rightBtn.layer.borderWidth = 0.5f;
     [_bottomView addSubview:_rightBtn];
     [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-15);
         make.height.mas_equalTo(28);
         make.centerY.mas_equalTo(self.bottomView);
         make.width.mas_equalTo(72);
     }];
     
     _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [_leftBtn setTitleColor:HEXColor(@"#4A4A4A", 1) forState:UIControlStateNormal];
     _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
     _leftBtn.layer.cornerRadius = 14.f;
     _leftBtn.layer.borderColor = HEXColor(@"#4A4A4A", 1).CGColor;
     _leftBtn.layer.borderWidth = 0.5f;
     [_bottomView addSubview:_leftBtn];
     [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-97);
         make.height.centerY.width.mas_equalTo(self.rightBtn);
     }];
}

- (void)setBtnStateWithStatus:(NSInteger)status {
    //右边按钮显示
    if (status == 1 || status == 4 || status == 6) {
        _rightBtn.hidden = NO;
    } else {
        _rightBtn.hidden = YES;
    }
    //左边按钮显示
    if (status == 1 || status == 3 || status == 4 || status == 7 || status == 8) {
        _leftBtn.hidden = NO;
    } else {
        _leftBtn.hidden = YES;
    }
    //更新按钮布局
    if (_rightBtn.hidden && !_leftBtn.hidden) {
        [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
        }];
    } else {
        [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-97);
        }];
    }
    //设置按钮文字
    switch (status) {
        case 1: //待付款
        {
            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            [_leftBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
            [_rightBtn addTarget:self action:@selector(payWithOrder) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 2: //待发货
        case 5: //待使用
        {
            _bottomView.hidden = YES;
            _tableView.height = SCREEN_HEIGHT - NAV_HEIGHT;
        }
            break;
        case 3: //已取消
        case 7: //已完成
        case 8: //已关闭
        {
            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [_leftBtn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4: //待收货
        {
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [_rightBtn addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
            [_leftBtn addTarget:self action:@selector(checkTheExpressVC) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 6: //待评价
        {
            [_rightBtn setTitle:@"立即评价" forState:UIControlStateNormal];
            [_rightBtn addTarget:self action:@selector(evaluateOrder) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 按钮点击事件
//复制订单号
- (void)copylinkBtnClick {
    if (self.dataSource.orderNo) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.dataSource.orderNo;
        [CddHud showTextOnly:@"复制成功" view:self.view];
    }
}

- (void)evaluateOrder {
    [CddHud showTextOnly:@"评价功能暂未开放哦～" view:self.view];
}

//查看发票详情
- (void)lookOverInvoice {
    InvoiceDetailVC *vc = [[InvoiceDetailVC alloc] init];
    vc.leftArray = self.invoiceLeftArray;
    vc.rightArray = self.invoiceRightArray;
    [self.navigationController pushViewController:vc animated:YES];
}

//查看物流
- (void)checkTheExpressVC {
    CheckTheExpressVC *vc = [[CheckTheExpressVC alloc] init];
    vc.expressCode = self.dataSource.expressCode;
    vc.expressNumber = self.dataSource.expressNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

//删除订单
- (void)deleteOrder {
    NSDictionary *dict = @{@"id":_orderID};
    [CddHud show:[HelperTool getCurrentVC].view];
    [NetTool putRequest:URLPut_Order_Delete Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        [CddHud showTextOnly:@"删除成功" view:[HelperTool getCurrentVC].view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } Error:^(id  _Nonnull json) {
        
    } Failure:^(NSError * _Nonnull error) {
    }];
}

//取消订单
- (void)cancelOrder {
    NSDictionary *dict = @{@"id":_orderID};
    [CddHud show:[HelperTool getCurrentVC].view];
    [NetTool putRequest:URLPut_Order_Cancel Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        [CddHud showTextOnly:@"订单已取消" view:[HelperTool getCurrentVC].view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
//        OrderModel *model = self.dataSource[section];
//        model.orderStatus = 3;
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } Error:^(id  _Nonnull json) {
        
    } Failure:^(NSError * _Nonnull error) {
    }];
}

//确认收货
- (void)confirmOrder {
    NSDictionary *dict = @{@"id":_orderID};
    [CddHud show:[HelperTool getCurrentVC].view];
    [NetTool putRequest:URLPut_Order_Confirm Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        [CddHud showTextOnly:@"订单已确认收货" view:[HelperTool getCurrentVC].view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
//        OrderModel *model = self.dataSource[section];
//        model.orderStatus = 7; //变成已完成状态
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    } Error:^(id  _Nonnull json) {
        
    } Failure:^(NSError * _Nonnull error) {
    }];
}

//订单号付款
- (void)payWithOrder {
    NSDictionary *dict = @{@"orderNo":self.dataSource.orderNo};
    [CddHud show:[HelperTool getCurrentVC].view];
    self.view.userInteractionEnabled = NO;
//    NSLog(@"------ %@",dict);
    [NetTool postRequest:URLPost_OrderNo_Pay Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:[HelperTool getCurrentVC].view];
        self.view.userInteractionEnabled = YES;
        PayModel *payModel = [PayModel mj_objectWithKeyValues:json];
        PayTheOrderVC *vc = [[PayTheOrderVC alloc] init];
        vc.payInfo = payModel;
        vc.startDate = [TimeAbout stringToDateSec:self.dataSource.orderTime];
        vc.totalMoney = self.dataSource.orderAmount;
        [self.navigationController pushViewController:vc animated:YES];
    } Error:^(id  _Nullable json) {
        self.view.userInteractionEnabled = YES;
    } Failure:^(NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - tableView delegate
//几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }
    else if (section == 3) {
        if (self.dataSource.isInvoice == 0) {
            return 0.001;
        }
        return 8;
    } else if (section == 4) {
        int status = self.dataSource.orderStatus;
        if (status == 1 || status == 2 ||  status == 3 || status == 5 || status == 8 ) {
            return 0.001;
        }
        return 8;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.dataSource.orderDataList.count;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        if (self.dataSource.isInvoice == 0) {
            return 0;
        }
        return 3;
    } else if (section == 4) {
        int status = self.dataSource.orderStatus;
        if (status == 1 || status == 2 ||  status == 3 || status == 5 || status == 8 ) {
            return 0;
        }
        return 1;
    } else if (section == 5) {
        return self.timeTxtArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.dataSource.addrCellHeight;
    } else if (indexPath.section == 1) {
        return 116;
    } else if (indexPath.section == 2) {
        return 34;
    } else if (indexPath.section == 3) {
        if (self.dataSource.isInvoice == 0) {
            return 0;
        }
        return 34;
    } else if (indexPath.section == 4) {
        int status = self.dataSource.orderStatus;
        if (status == 1 || status == 2 ||  status == 3 || status == 5 || status == 8 ) {
            return 0;
        }
        return 48;
    } else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            return 48;
        }
        return 34;
    }
    return 0;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AddressDisplayTBCell *cell = [AddressDisplayTBCell cellWithTableView:tableView];
        cell.model = self.dataSource;
        return cell;
    } else if (indexPath.section == 1) {
        OrderGoodsTBCell *cell = [OrderGoodsTBCell cellWithTableView:tableView];
        cell.type = 0;
        cell.model = self.dataSource.orderDataList[indexPath.row];
        return cell;
    } else {
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
        OrderDetailInfoTBCell *cell = [OrderDetailInfoTBCell cellWithTableView:tableView identifier:CellIdentifier];
        [self setInfoCellDataWitiCell:cell indexPath:indexPath];
        return cell;
    }
}

- (void)setInfoCellDataWitiCell:(OrderDetailInfoTBCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSString *text = [NSString string];
        NSString *value = [NSString string];
        if (_dataSource.orderStatus == 1 || _dataSource.orderStatus == 3) {
            text = @"需付款";
            value = _dataSource.orderAmount;
        } else {
            text = @"实付款";
            value = _dataSource.payAmount;
        }
        NSArray *leftTitleArr = @[@"商品总额",@"运费",text];
        NSArray *rightTitleArr = @[[NSString stringWithFormat:@"¥ %@",_dataSource.goodsAmount],
                                   [NSString stringWithFormat:@"¥ %@",_dataSource.orderFreight],
                                   [NSString stringWithFormat:@"¥ %@",value]];
        cell.LeftLab.text = leftTitleArr[indexPath.row];
        cell.rightLab.text = rightTitleArr[indexPath.row];
        if (indexPath.row == 2) {
            cell.LeftLab.textColor = HEXColor(@"#343333", 1);
            cell.LeftLab.font = [UIFont systemFontOfSize:14];
            cell.rightLab.textColor = HEXColor(@"#FF5100", 1);
            cell.rightLab.font = [UIFont systemFontOfSize:14];
        }
    }
    //发票
    else if (indexPath.section == 3) {
        if (self.dataSource.isInvoice == 1) {
            NSString *type = _dataSource.invoiceType == 1 ? @"普通发票" : @"增值税专用发票";
            NSArray *leftTitleArr = @[[NSString stringWithFormat:@"发票类型: %@",type],
                                      [NSString stringWithFormat:@"发票抬头: %@",_dataSource.invoiceTitle],
                                      [NSString stringWithFormat:@"发票内容: %@",_dataSource.invoiceContent]];
            cell.LeftLab.text = leftTitleArr[indexPath.row];
            if (indexPath.row == 1) {
                cell.disType = 1;
                [cell.rightBtn setTitle:@"查看发票" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(lookOverInvoice) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    //物流
    else if (indexPath.section == 4) {
        int status = self.dataSource.orderStatus;
        if (status == 4 || status == 6 ||  status == 7) {
            cell.LeftLab.text = [NSString stringWithFormat:@"%@: %@",_dataSource.expressName,_dataSource.expressNumber];
            cell.disType = 1;
            [cell.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [cell.rightBtn addTarget:self action:@selector(checkTheExpressVC) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if (indexPath.section == 5) {
        cell.LeftLab.text = self.timeTxtArray[indexPath.row];
        cell.rightLab.text = self.timeArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.disType = 1;
            [cell.rightBtn setTitle:@"复制" forState:UIControlStateNormal];
            [cell.rightBtn addTarget:self action:@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}





/**
 1：下单时间
 2：下单时间  orderTime
 支付时间 deliverAt
 3：下单时间  orderTime

 4：下单时间  orderTime
 发货时间 deliverAt
 6：下单时间  orderTime
 发货时间 deliverAt
 收货时间  confirmAt
 7：下单时间  orderTime
 发货时间 deliverAt
 收货时间  confirmAt
 评价时间 evaluateAt
 8：下单时间  orderTime
 发货时间 deliverAt
 收货时间  confirmAt
 评价时间 evaluateAt
 */
@end
