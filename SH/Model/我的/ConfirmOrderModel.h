//
//  ConfirmOrderModel.h
//  SH
//
//  Created by i7colors on 2019/12/21.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConfirmOrderGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderModel : NSObject
//店铺名称
@property (nonatomic, copy) NSString *shopName;
//下单信息返回数据
@property (nonatomic, strong) NSMutableArray<ConfirmOrderGoodsModel *> *goodsList;
@end

@interface ConfirmOrderGoodsModel : NSObject
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品图片
@property (nonatomic, copy) NSString *logo;
//商品价格
@property (nonatomic, copy) NSDecimalNumber *goodsPrice;
//市场价格
@property (nonatomic, copy) NSString *goodsMarketPrice;
//商品规格
@property (nonatomic, copy) NSString *skuName;
//商品数量
@property (nonatomic, assign) NSInteger goodsNum;
//skuId
@property (nonatomic, copy) NSString *skuId;
//商品id
@property (nonatomic, copy) NSString *goodsId;

@end
NS_ASSUME_NONNULL_END
