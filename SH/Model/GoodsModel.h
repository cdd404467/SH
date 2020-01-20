//
//  GoodsModel.h
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsModel : NSObject
//商品id
@property (nonatomic, assign) int goodsId;
//商品缩略图
@property (nonatomic, copy) NSString *logo;
//销量
@property (nonatomic, copy) NSString *saleCount;
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品价格
@property (nonatomic, copy) NSString *goodsPrice;
//店铺图标
@property (nonatomic, copy) NSString *shopLogo;
@end



@interface GoodsDetailModel : NSObject
//商品id
@property (nonatomic, assign) int goodsId;
//轮播图
@property (nonatomic, copy) NSString *banner;
//轮播图arr
@property (nonatomic, copy) NSArray *bannerArray;
//销量
@property (nonatomic, copy) NSString *saleCount;
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品价格
@property (nonatomic, copy) NSString *goodsPrice;
//市场价
@property (nonatomic, copy) NSString *goodsMarketPrice;
//是否收藏 true false
@property (nonatomic, assign) BOOL isCollect;
//评论数量
@property (nonatomic, copy) NSString *evaluateCount;
//商品详情
@property (nonatomic, copy) NSString *goodsDetail;
//商品规格
@property (nonatomic, copy) NSArray *specList;
//skuList
@property (nonatomic, copy) NSArray *skuList;
//评论列表
@property (nonatomic, copy) NSArray *evaluateList;

//html cell height
@property (nonatomic, assign) CGFloat cellHeight;
@end


@interface SpecListModel : NSObject
//goodsID
@property (nonatomic, copy) NSString *goodsId;
//
@property (nonatomic, copy) NSArray *goodsSkuSpecVals;
//规格类名
@property (nonatomic, copy) NSString *goodsSpecName;
@end


@interface GoodsSkuSpecValsModel : NSObject
//规格名字
@property (nonatomic, copy) NSString *goodsSkuSpecValName;
//是否选中
@property (nonatomic, assign) BOOL isSelected;
//cell 宽度
@property (nonatomic, assign) CGFloat cellWidth;
@end

@interface SkuListModel : NSObject
//商品ID
@property (nonatomic, assign) int goodsId;
//sku id
@property (nonatomic, assign) int skuId;
//sku name
@property (nonatomic, copy) NSString *goodsSkuName;
//
@property (nonatomic, copy) NSArray *skuNameArr;
//当前价格
@property (nonatomic, copy) NSString *goodsSkuRetailPrice;
//市场价格
@property (nonatomic, copy) NSString *goodsSkuMarketPrices;
//库存
@property (nonatomic, assign) int goodsSkuStock;
//图片
@property (nonatomic, copy) NSString *goodsSkuImg;
@end

NS_ASSUME_NONNULL_END
