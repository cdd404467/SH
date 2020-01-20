//
//  OrderModel.h
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject
//创建时间
@property (nonatomic, copy) NSString *orderTime;
//订单状态:1-待支付,2-已支付(待发货),3-已取消,4-已发货(待收货),5-待使用，6-已收货(待评价),7-已完成
//8 :订单关闭
@property (nonatomic, assign) int orderStatus;
//店铺名称
@property (nonatomic, copy) NSString *shopName;
//商品
@property (nonatomic, strong) NSMutableArray *orderDataList;
@property (nonatomic, strong) NSMutableArray<OrderGoodsModel *> *goodsList;
//合计
@property (nonatomic, copy) NSDecimalNumber *orderAmount;
//订单ID
@property (nonatomic, copy) NSString *orderID;
//订单号
@property (nonatomic, copy) NSString *orderNo;

//快递名称
@property (nonatomic, copy) NSString *expressName;
//快递单号
@property (nonatomic, copy) NSString *expressNumber;
//快递编号
@property (nonatomic, copy) NSString *expressCode;
@end


@interface OrderGoodsModel : NSObject
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品图片
@property (nonatomic, copy) NSString *goodsImg;
////商品图片 ------(logo)
@property (nonatomic, copy) NSString *logo;
//商品价格
@property (nonatomic, copy) NSDecimalNumber *goodsPrice;
//市场价格
@property (nonatomic, copy) NSString *goodsMarketPrice;
//商品数量
@property (nonatomic, assign) NSInteger goodsNum;
//商品规格
@property (nonatomic, copy) NSString *skuName;
//skuId
@property (nonatomic, copy) NSString *skuId;
//商品id
@property (nonatomic, copy) NSString *gId;
@end


@interface OrderDetailModel : NSObject
//订单状态:1-待支付,2-已支付(待发货),3-已取消,4-已发货(待收货),5-待使用，6-已收货(待评价),7-已完成
//8 :订单关闭
@property (nonatomic, assign) int orderStatus;
//订单号
@property (nonatomic, copy) NSString *orderNo;
//商品
@property (nonatomic, strong) NSMutableArray *orderDataList;
//-------地址字段
//收件人手机号
@property (nonatomic, copy) NSString *receiptPhone;
//收件人名字
@property (nonatomic, copy) NSString *receiptPerson;
//收件人地址
@property (nonatomic, copy) NSString *receiptAddr;
//省
@property (nonatomic, copy) NSString *receiptProvince;
//市
@property (nonatomic, copy) NSString *receiptCity;
//区
@property (nonatomic, copy) NSString *receiptArea;
//地址cell高度
@property (nonatomic, assign) CGFloat addrCellHeight;

//--------金额
//需付款金额
@property (nonatomic, copy) NSString *payAmount;
//实付款金额
@property (nonatomic, copy) NSString *orderAmount;
//商品总金额
@property (nonatomic, copy) NSString *goodsAmount;
//运费
@property (nonatomic, copy) NSString *orderFreight;

//---------发票
//是否有发票,0 无 1 有
@property (nonatomic, assign) BOOL isInvoice;
//1 普通发票 2 增值税专用发票
@property (nonatomic, assign) NSInteger invoiceType;
//发票抬头
@property (nonatomic, copy) NSString *invoiceTitle;
//发票内容
@property (nonatomic, copy) NSString *invoiceContent;
//发票性质,1 个人 2 单位
@property (nonatomic, assign) NSInteger normalType;
//昵称
@property (nonatomic, copy) NSString *invoiceNickname;
//地址
@property (nonatomic, copy) NSString *invoiceAddress;
//企业名称
@property (nonatomic, copy) NSString *invoiceEnterpriseName;
//税号
@property (nonatomic, copy) NSString *invoiceTaxCode;
//注册地址
@property (nonatomic, copy) NSString *invoiceLoginAddress;
//收票人电话
@property (nonatomic, copy) NSString *invoiceMobile;
//开户行
@property (nonatomic, copy) NSString *invoiceBankName;
//银行账户
@property (nonatomic, copy) NSString *invoiceAccount;


//快递名称
@property (nonatomic, copy) NSString *expressName;
//快递单号
@property (nonatomic, copy) NSString *expressNumber;
//快递编号
@property (nonatomic, copy) NSString *expressCode;

//---------时间相关
//下单时间
@property (nonatomic, copy) NSString *orderTime;
//发货时间
@property (nonatomic, copy) NSString *deliverAt;
//收货时间
@property (nonatomic, copy) NSString *confirmAt;
//评价时间
@property (nonatomic, copy) NSString *evaluateAt;

@end


NS_ASSUME_NONNULL_END
