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
@property (nonatomic, assign) NSInteger saleCount;
//商品名称
@property (nonatomic, copy) NSString *goodsName;
//商品价格
@property (nonatomic, copy) NSString *goodsPrice;
//店铺图标
@property (nonatomic, copy) NSString *shopLogo;
@end

NS_ASSUME_NONNULL_END
