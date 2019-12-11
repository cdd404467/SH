//
//  ShopCarSectionHeader.h
//  SH
//
//  Created by i7colors on 2019/9/26.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCarModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectStoreBlock)(NSIndexPath *atIndexPath);
@interface ShopCarSectionHeader : UICollectionReusableView
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ShopCarModel *model;
@property (nonatomic, copy) SelectStoreBlock selectStoreBlock;
@end

NS_ASSUME_NONNULL_END
