//
//  ShopModel.h
//  SH
//
//  Created by i7colors on 2019/9/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassifyListModel;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 店铺列表
@interface ShopModel : NSObject
//店铺id
@property (nonatomic, copy) NSString *shopId;
//店铺logo
@property (nonatomic, copy) NSString *logo;
//店铺名称
@property (nonatomic, copy) NSString *name;
//标签名称
@property (nonatomic, copy) NSString *labelNames;
//标签数组
@property (nonatomic, copy) NSArray *labelArray;
//热度
@property (nonatomic, copy) NSString *viewNum;
@end



#pragma mark - 店铺主页
@interface ShopHomePageModel : NSObject
//店铺id
@property (nonatomic, copy) NSString *shopId;
//艺术家id
@property (nonatomic, copy) NSString *synopsisId;
//店铺名称
@property (nonatomic, copy) NSString *name;
//店铺logo
@property (nonatomic, copy) NSString *shopLogo;
//是否收藏店铺
@property (nonatomic, assign) BOOL isCollect;
//轮播图列表
@property (nonatomic, copy) NSArray<NSString *> *bannerList;
//分类列表
@property (nonatomic, copy) NSArray<ClassifyListModel *> *classifyList;


//是否有简介
@property (nonatomic, assign) NSInteger isSynopsis;
//是否有商品(衍生品)
@property (nonatomic, assign) NSInteger isGoods;
//是否有作品
@property (nonatomic, assign) NSInteger isOriginal;
@end

@interface ClassifyListModel : NSObject
@property (nonatomic, copy) NSString *classifyId;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
