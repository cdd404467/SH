//
//  HomePageModel.h
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneModel.h"
#import "DesignerModel.h"
#import "GoodsModel.h"
#import "BannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageModel : NSObject
//Banner
@property (nonatomic, copy) NSArray *BANNER;
//热门场景
@property (nonatomic, copy) NSArray *SCENE;
//设计师
@property (nonatomic, copy) NSArray *DESIGNER;
//热门商品
@property (nonatomic, copy) NSArray *GOODS;
//一级场景
@property (nonatomic, copy) NSArray *FIRSTSCENE;
//
@property (nonatomic, assign) BOOL isPullDown;
@end

NS_ASSUME_NONNULL_END
