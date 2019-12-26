//
//  ShopCarCVCell.h
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopGoodsModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectGoodsBlock)(NSIndexPath *atIndexPath);
typedef void(^ChangeCountBlock)(NSIndexPath *atIndexPath, NSInteger count ,NSString *carID ,NSInteger type);//type 0是减，1是加
typedef void(^ChangeCountErrorBlock)(NSString *error);
@interface ShopCarCVCell : UICollectionViewCell
@property (nonatomic, strong) ShopGoodsModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) SelectGoodsBlock selectGoodsBlock;
@property (nonatomic, copy) ChangeCountBlock changeCountBlock;
@property (nonatomic, copy) ChangeCountErrorBlock changeCountErrorBlock;
@end

NS_ASSUME_NONNULL_END
