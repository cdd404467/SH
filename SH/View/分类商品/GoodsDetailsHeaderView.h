//
//  GoodsDetailsHeaderView.h
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectBlock)(void);
@interface GoodsDetailsHeaderView : UIView
@property (nonatomic, strong) NSMutableDictionary *specValue;
@property (nonatomic, strong) GoodsDetailModel *model;
@property (nonatomic, copy) SelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
