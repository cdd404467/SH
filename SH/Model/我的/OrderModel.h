//
//  OrderModel.h
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (nonatomic, copy) NSArray *orderDataList;
//合计
@property (nonatomic, copy) NSDecimalNumber *orderAmount;
@end

@interface OrderGoodsModel : NSObject
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品图片
@property (nonatomic, copy) NSString *goodsImg;
//商品价格
@property (nonatomic, copy) NSDecimalNumber *goodsPrice;
//市场价格
@property (nonatomic, copy) NSString *goodsMarketPrice;
//商品数量
@property (nonatomic, assign) NSInteger goodsNum;
//商品规格
@property (nonatomic, copy) NSString *skuName;

@end


NS_ASSUME_NONNULL_END
