//
//  ConfirmOrderVC.m
//  SH
//
//  Created by i7colors on 2019/12/13.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "OrderGoodsTBCell.h"
#import "OrderModel.h"
#import "AddressModel.h"
#import "InvoiceModel.h"
#import "NetTool.h"
#import "ReceiverAddressVC.h"
#import "MyInvoiceVC.h"
#import "UIView+Border.h"
#import "CddHud.h"
#import "PayTheOrderVC.h"
#import "PayModel.h"
#import "OrderDetailVC.h"


@interface ConfirmOrderVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ConfirmOrderHeader *headerView;
@property (nonatomic, strong) ConfirmOrderFooter *footerView;
@property (nonatomic, copy) NSArray *addressDataSource;
@property (nonatomic, strong) UILabel *totalMoneyLab;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, copy) NSString *totalMoney;
@property (nonatomic, copy) NSString *yunfeiMoney;
@property (nonatomic, strong) InvoiceModel *invoiceModel;
@property (nonatomic, copy) NSArray<OrderModel *> *dataSource;

@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"确认订单";
    [self.view addSubview:self.tableView];
    [self getPayInfo];
    [self setupUI];
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
        _headerView = [[ConfirmOrderHeader alloc] init];
        DDWeakSelf;
        _headerView.changeHeightBlock = ^(CGFloat height) {
            [weakself.tableView reloadData];
        };
        _headerView.tapViewBlock = ^{
            ReceiverAddressVC *vc = [[ReceiverAddressVC alloc] init];
            vc.navTitle = @"选择收货地址";
            vc.selectAddressBlock = ^(AddressModel * _Nonnull model) {
                weakself.headerView.model = model;
                [weakself getFreightWithID:@(model.addressID).stringValue];
            };
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        _tableView.tableHeaderView = _headerView;
        
        _footerView = [[ConfirmOrderFooter alloc] init];
        _tableView.tableFooterView = _footerView;
        _footerView.money = self.money;
        _footerView.tapInvoiceViewBlock = ^{
            MyInvoiceVC *vc = [[MyInvoiceVC alloc] init];
            vc.navTitle = @"选择发票";
            vc.selectInvoiceBlock = ^(InvoiceModel * _Nonnull model) {
                weakself.footerView.invoiceLab.text = model.title;
                weakself.invoiceModel = model;
            };
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return _tableView;
}

#pragma mark 请求数据
//计算运费
- (void)getFreightWithID:(NSString *)addressID {
    NSMutableArray *goodsList = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.goodsInfoList) {
        NSDictionary *valueDict = @{@"id":dict[@"id"], @"goodsNum":dict[@"goodsNum"]};
        [goodsList addObject:valueDict];
    }
    NSDictionary *dict = @{@"goodsList":goodsList,
                           @"shipId":addressID
    };
    [CddHud show:self.view];
    self.payBtn.enabled = NO;
    [NetTool putRequest:URLPut_Freight_Pay Params:dict Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        [CddHud hideHUD:self.view];
        self.payBtn.enabled = YES;
        json = [json stringValue];
        self.footerView.yunfeiLab.text = [NSString stringWithFormat:@"¥%@",json];
        NSDecimalNumber *goodsMoney = [NSDecimalNumber decimalNumberWithString:self.money];
        NSDecimalNumber *yufeiMoney = [NSDecimalNumber decimalNumberWithString:json];
        NSDecimalNumber *total = [goodsMoney decimalNumberByAdding:yufeiMoney];
        self.yunfeiMoney = yufeiMoney.stringValue;
        self.totalMoney = total.stringValue;
        self.totalMoneyLab.text = [NSString stringWithFormat:@"¥%@",self.totalMoney];
    } Error:nil Failure:^(NSError * _Nonnull error) {
        self.payBtn.enabled = YES;
        [CddHud hideHUD:self.view];
    }];
}

//获取下单信息
- (void)getPayInfo {
    [NetTool putRequest:URLPut_Order_PayInfo Params:_goodsInfoList Success:^(id  _Nonnull json) {
        //转字典
//        NSLog(@" ==----   %@",json);
        if (isRightData(To_String(json[@"address"]))) {
            AddressModel *model = [AddressModel mj_objectWithKeyValues:json[@"address"]];
            self.headerView.model = model;
            [self getFreightWithID:@(model.addressID).stringValue];
        }
        self.dataSource = [OrderModel mj_objectArrayWithKeyValuesArray:json[@"goodsList"]];
        for (OrderModel *carModel in self.dataSource) {
            carModel.goodsList = [OrderGoodsModel mj_objectArrayWithKeyValuesArray:carModel.goodsList];
        }
        
        [self.tableView reloadData];
    } Error:nil Failure:^(NSError * _Nonnull error) {
//            self.payBtn.enabled = YES;
//            [CddHud hideHUD:self.view];
    }];
}

//下单
- (void)payMoney {
    [self.view endEditing:YES];
    if (_headerView.addressLab.text.length < 7) {
        [CddHud showTextOnly:@"请选择收货地址" view:self.view];
        return;
    }
    
    NSMutableArray *orderList = [NSMutableArray arrayWithCapacity:0];
    for (OrderModel *car in self.dataSource) {
        for (OrderGoodsModel *goods in car.goodsList) {
            NSDictionary *valueDict = @{@"id":goods.gId,
                                        @"skuId":goods.skuId,
                                        @"goodsNum":@(goods.goodsNum).stringValue};
            [orderList addObject:valueDict];
        }
    }
    NSDictionary *dict = @{@"orderDataList":orderList,
                           @"orderRemarks":_footerView.bakTF.text,
                           @"shipId":@(_headerView.model.addressID),
                           @"isCarPay":@(_isCarPay),
                           @"orderAmount":self.totalMoney,
                           @"orderFreight":self.yunfeiMoney,
                           @"isInvoice":_invoiceModel ? @1 : @0,
                           @"invoiceId":_invoiceModel ? _invoiceModel.invoiceID : @0,
                           @"isBargain":@(_isBargain),
                           @"orderSource":@3
//                           @"clientIp":[HelperTool getIPaddress]
    };
  
    [CddHud showWithText:@"请稍等..." view:self.view];
    self.payBtn.enabled = NO;
    [NetTool postRequest:URLPost_Pay_Money Params:dict Success:^(id  _Nonnull json) {
//        NSLog(@"json----- %@",json);
        [CddHud hideHUD:self.view];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_RemoveCarHasSelectedGoods object:nil userInfo:nil];
        self.payBtn.enabled = YES;
        __block PayModel *model = [PayModel mj_objectWithKeyValues:json];
        PayTheOrderVC *vc = [[PayTheOrderVC alloc] init];
        DDWeakSelf;
        vc.orderChangeBlock = ^{
            NSMutableArray *newArr = [weakself.navigationController.viewControllers mutableCopy];
            for (UIViewController *vc in weakself.navigationController.viewControllers) {
                if (vc == weakself) {
                    NSInteger index = [newArr indexOfObject:vc];
                    OrderDetailVC *newVC = [[OrderDetailVC alloc] init];
                    newVC.orderID = model.orderId;
                    [newArr replaceObjectAtIndex:index withObject:newVC];
                }
            }
            weakself.navigationController.viewControllers = [newArr copy];
        };
        vc.payInfo = model;
        vc.startDate = [NSDate date];
        vc.totalMoney = self.totalMoney;
        [self.navigationController pushViewController:vc animated:YES];
    } Error:^(id  _Nullable json) {
        self.payBtn.enabled = YES;
    } Failure:^(NSError * _Nonnull error) {
        self.payBtn.enabled = YES;
    }];
}

- (void)setupUI {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"总计: ";
    txtLab.font = [UIFont systemFontOfSize:15];
    txtLab.textColor = HEXColor(@"#090203", 1);
    [bottomView addSubview:txtLab];
    [txtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(bottomView);
    }];
    
    _totalMoneyLab = [[UILabel alloc] init];
    _totalMoneyLab.text = [NSString stringWithFormat:@"¥0"];
    _totalMoneyLab.textColor = HEXColor(@"#FF5100", 1);
    _totalMoneyLab.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:_totalMoneyLab];
    [_totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(txtLab.mas_right).offset(3);
        make.height.centerY.mas_equalTo(txtLab);
        make.right.mas_lessThanOrEqualTo(-110);
    }];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setTitle:@"立即下单" forState:UIControlStateNormal];
    [_payBtn setTintColor:UIColor.whiteColor];
    _payBtn.adjustsImageWhenHighlighted = NO;
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _payBtn.enabled = NO;
    [_payBtn addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(100);
    }];
    [_payBtn.superview layoutIfNeeded];
    [_payBtn setBackgroundImage:[HelperTool globalGradientColor:_payBtn.bounds] forState:UIControlStateNormal];
    [_payBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#d6d6d6", 1)] forState:UIControlStateDisabled];
}

#pragma mark - tableView delegate
//几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ConfirmOrderSectionHeader *header = [ConfirmOrderSectionHeader headerWithTableView:tableView];
    OrderModel *model = self.dataSource[section];
    header.title = model.shopName;
    return header;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].goodsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderGoodsTBCell *cell = [OrderGoodsTBCell cellWithTableView:tableView];
    OrderModel *model = self.dataSource[indexPath.section];
    cell.type = 1;
    cell.model = model.goodsList[indexPath.row];
    return cell;
}
@end

@implementation ConfirmOrderSectionHeader {
    UILabel *_shopNameLab;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _shopNameLab = [[UILabel alloc] init];
    _shopNameLab.textColor = HEXColor(@"#090203", 1);
    _shopNameLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_shopNameLab];
    [_shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.width.mas_equalTo(SCREEN_WIDTH - 42);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _shopNameLab.text = title;
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ConfirmOrderSectionHeader";
    // 1.缓存中取
    ConfirmOrderSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[ConfirmOrderSectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}
@end

@interface ConfirmOrderHeader()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *receiverLab;
@property (nonatomic, strong) UILabel *phoneLab;
@end

@implementation ConfirmOrderHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44 + 9);
        [self setupUI];
    }
    return self;
}

- (void)tapView {
    if (self.tapViewBlock) {
        self.tapViewBlock();
    }
}

- (void)setupUI {
    _bgView = [[UIView alloc] init];
    _bgView.frame =CGRectMake(0, 0, SCREEN_WIDTH, 44);
    _bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_bgView];
    [HelperTool addTapGesture:_bgView withTarget:self andSEL:@selector(tapView)];
    
    
    UIImageView *localImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon"]];
    [_bgView addSubview:localImg];
    [localImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self.bgView);
        make.height.mas_equalTo(17);
    }];

    UIImageView *rightRowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
    [_bgView addSubview:rightRowImg];
    [rightRowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(localImg);
    }];

    _receiverLab = [[UILabel alloc] init];
    _receiverLab.font = [UIFont systemFontOfSize:14];
    _receiverLab.textColor = HEXColor(@"#4A4A4A", 1);
    _receiverLab.text = @"添加收货地址";
    [_bgView addSubview:_receiverLab];
    [_receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(localImg.mas_right).offset(10);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(130);
    }];

    _phoneLab = [[UILabel alloc] init];
    _phoneLab.textAlignment = NSTextAlignmentRight;
    _phoneLab.font = _receiverLab.font;
    _phoneLab.textColor = _receiverLab.textColor;
    [self addSubview:_phoneLab];
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightRowImg.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.receiverLab);
        make.height.mas_equalTo(self.receiverLab);
        make.left.mas_equalTo(self.receiverLab.mas_right).offset(5);
    }];

    _addressLab = [[UILabel alloc] init];
    _addressLab.font = _receiverLab.font;
    _addressLab.numberOfLines = 0;
    _addressLab.textColor = _receiverLab.textColor;
    [_bgView addSubview:_addressLab];
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiverLab);
        make.right.mas_equalTo(self.phoneLab);
        make.top.mas_equalTo(self.receiverLab.mas_bottom).offset(5);
    }];
}

- (void)setModel:(AddressModel *)model {
    _model = model;
    _receiverLab.text = [NSString stringWithFormat:@"收货人: %@",model.name];
    _phoneLab.text = model.phone;
    _addressLab.text = [NSString stringWithFormat:@"收货地址: %@%@%@%@",model.provinceName,model.cityName,model.districtName,model.address];
    [_addressLab.superview layoutIfNeeded];
    _bgView.height = _addressLab.bottom + 12;
    self.height = _bgView.height + 9;
    if (self.changeHeightBlock) {
        self.changeHeightBlock(self.height);
    }
}

@end

@interface ConfirmOrderFooter()
@property (nonatomic, strong) UILabel *totalGoodsMoneyLab;
@end

@implementation ConfirmOrderFooter
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50 * 5 + 8 * 3);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSArray *titleArr = @[@"商品金额",@"运费",@"发票",@"备注"];
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 8, SCREEN_WIDTH, 50);
        view.backgroundColor = UIColor.whiteColor;
        [self addSubview:view];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = HEXColor(@"#4A4A4A", 1);
        titleLab.text = titleArr[i];
        [view addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(view);
            make.height.mas_equalTo(30);
        }];
        if (i == 0 || i == 2) {
            [view addBorder:RGBA(232, 232, 232, 1) width:0.5 direction:BorderDirectionBottom];
        }
        if (i == 0) {
            _totalGoodsMoneyLab = [[UILabel alloc] init];
            _totalGoodsMoneyLab.textAlignment = NSTextAlignmentRight;
            _totalGoodsMoneyLab.textColor = HEXColor(@"#FF5100", 1);
            _totalGoodsMoneyLab.font = [UIFont systemFontOfSize:14];
            [view addSubview:_totalGoodsMoneyLab];
            [_totalGoodsMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(view);
            }];
        }
        else if (i == 1) {
            view.top = 8 + 50;
            _yunfeiLab = [[UILabel alloc] init];
            _yunfeiLab.textAlignment = NSTextAlignmentRight;
            _yunfeiLab.textColor = HEXColor(@"#4A4A4A", 1);
            _yunfeiLab.font = [UIFont systemFontOfSize:14];
            [view addSubview:_yunfeiLab];
            [_yunfeiLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(view);
            }];
        }
        else if (i == 2) {
            view.top = 16 + 50 * 2;
            UIImageView *rightRowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
            [view addSubview:rightRowImg];
            [rightRowImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(6);
                make.height.mas_equalTo(12);
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(view);
            }];
            
            _invoiceLab = [[UILabel alloc] init];
            _invoiceLab.text = @"请选择";
            _invoiceLab.textAlignment = NSTextAlignmentRight;
            _invoiceLab.textColor = HEXColor(@"#4A4A4A", 1);
            _invoiceLab.font = [UIFont systemFontOfSize:14];
            [view addSubview:_invoiceLab];
            [_invoiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(rightRowImg.mas_left).offset(-10);
                make.height.mas_equalTo(30);
                make.left.mas_equalTo(70);
                make.centerY.mas_equalTo(view);
            }];
            [HelperTool addTapGesture:view withTarget:self andSEL:@selector(selectInvoice)];
        }
        else if (i == 3) {
            view.top = 16 + 50 * 3;
            _bakTF = [[UITextField alloc] init];
            _bakTF.placeholder = @"选填,可填写您的要求";
            _bakTF.font = [UIFont systemFontOfSize:14];
            _bakTF.textColor = HEXColor(@"#4A4A4A", 1);
            _bakTF.tintColor = HEXColor(@"#FF5100", 1);
            [view addSubview:_bakTF];
            [_bakTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KFit_W(90));
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(40);
                make.centerY.mas_equalTo(view);
            }];
        }
//        else if (i == 4) {
//            view.top = 24 + 50 * 4;
//            UILabel *lab = [[UILabel alloc] init];
//            lab.text = @"微信支付";
//            lab.textAlignment = NSTextAlignmentRight;
//            lab.textColor = HEXColor(@"#4A4A4A", 1);
//            lab.font = [UIFont systemFontOfSize:14];
//            [view addSubview:lab];
//            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-15);
//                make.height.mas_equalTo(30);
//                make.centerY.mas_equalTo(view);
//            }];
//        }
    }
}

- (void)selectInvoice {
    if (self.tapInvoiceViewBlock) {
        self.tapInvoiceViewBlock();
    }
}

- (void)setMoney:(NSString *)money {
    _totalGoodsMoneyLab.text = [NSString stringWithFormat:@"¥%@",money];
}


@end
