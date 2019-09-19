//
//  HomeDesignerSectionCell.h
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesignerModel;
NS_ASSUME_NONNULL_BEGIN

@interface HomeDesignerSectionCell : UICollectionViewCell
@property (nonatomic, strong) DesignerModel *model;
@property (nonatomic, assign) NSInteger rank;
@end

NS_ASSUME_NONNULL_END
