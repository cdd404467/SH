//
//  ShopCarModel.h
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface ShopCarModel : NSObject
//店铺名称
@property (nonatomic, copy) NSString *shopName;
//店铺下的商品数组
@property (nonatomic, strong) NSMutableArray<ShopGoodsModel *> *carGoodsList;
//下单信息返回数据
@property (nonatomic, strong) NSMutableArray<ShopGoodsModel *> *goodsList;
//是否选中该店铺
@property (nonatomic, assign) BOOL isSelected;
@end


@interface ShopGoodsModel : NSObject
//购物车id
@property (nonatomic, copy) NSString *shopCarID;
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品图片
@property (nonatomic, copy) NSString *goodsImg;
//下单信息
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



//是否选中该商品
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
