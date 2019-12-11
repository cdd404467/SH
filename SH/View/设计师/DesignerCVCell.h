//
//  DesignerCVCell.h
//  SH
//
//  Created by i7colors on 2019/9/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesignerModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(void);
@interface DesignerCVCell : UICollectionViewCell
@property (nonatomic, strong) DesignerModel *model;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
