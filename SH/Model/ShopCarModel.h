//
//  ShopCarModel.h
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopCarModel : NSObject
//店铺名称
@property (nonatomic, copy) NSString *shopName;
//店铺下的商品数组
@property (nonatomic, strong) NSMutableArray *carGoodsList;

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
//商品价格
@property (nonatomic, copy) NSDecimalNumber *goodsPrice;
//商品规格
@property (nonatomic, copy) NSString *skuName;
//商品数量
@property (nonatomic, assign) NSInteger goodsNum;

//是否选中该商品
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
