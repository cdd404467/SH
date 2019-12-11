//
//  ShopModel.h
//  SH
//
//  Created by i7colors on 2019/9/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopModel : NSObject
//店铺id
@property (nonatomic, copy) NSString *shopId;
//店铺logo
@property (nonatomic, copy) NSString *logo;
//店铺名称
@property (nonatomic, copy) NSString *name;
//标签名称
@property (nonatomic, copy) NSString *labelNames;
//热度
@property (nonatomic, copy) NSString *viewNum;
@end

NS_ASSUME_NONNULL_END
