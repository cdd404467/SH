//
//  SpecSelectCVCell.h
//  SH
//
//  Created by i7colors on 2019/12/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsSkuSpecValsModel;

#define Cell_Height 26
NS_ASSUME_NONNULL_BEGIN

@interface SpecSelectCVCell : UICollectionViewCell
@property (nonatomic, strong) GoodsSkuSpecValsModel *model;
@end

NS_ASSUME_NONNULL_END
