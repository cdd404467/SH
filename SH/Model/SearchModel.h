//
//  SearchModel.h
//  SH
//
//  Created by i7colors on 2019/12/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchModel : NSObject
//设计师
@property (nonatomic, copy) NSArray *DESIGNER;
//商品
@property (nonatomic, copy) NSArray *GOODS;
//素材
@property (nonatomic, copy) NSArray *MATERIAL;
//场景
@property (nonatomic, copy) NSArray *SCENE;
//店铺
@property (nonatomic, copy) NSArray *SHOP;
@end

NS_ASSUME_NONNULL_END
