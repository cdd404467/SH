//
//  ConfirmOrderVC.h
//  SH
//
//  Created by i7colors on 2019/12/13.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"
@class ShopCarModel;
@class AddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderVC : BaseViewController
//商品总价
@property (nonatomic, copy) NSString *money;
//是否购物车支付
@property (nonatomic, assign) BOOL isCarPay;
//是否砍价活动
@property (nonatomic, assign) BOOL isBargain;
//商品信息数组
@property (nonatomic, copy) NSArray *goodsInfoList;
@end

@interface ConfirmOrderSectionHeader : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *title;
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end


typedef void(^TapViewBlock)(void);
typedef void(^ChangeHeightBlock)(CGFloat height);
@interface ConfirmOrderHeader : UIView
@property (nonatomic, copy) ChangeHeightBlock changeHeightBlock;
@property (nonatomic, copy) TapViewBlock tapViewBlock;
@property (nonatomic, strong) AddressModel *model;
@property (nonatomic, strong) UILabel *addressLab;
@end

typedef void(^TapInvoiceViewBlock)(void);
@interface ConfirmOrderFooter : UIView
@property (nonatomic, strong) UILabel *yunfeiLab;
@property (nonatomic, strong) UILabel *invoiceLab;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) TapInvoiceViewBlock tapInvoiceViewBlock;
@property (nonatomic, strong) UITextField *bakTF;
@end
NS_ASSUME_NONNULL_END
