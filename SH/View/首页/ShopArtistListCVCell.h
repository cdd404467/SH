//
//  ShopArtistListCVCell.h
//  SH
//
//  Created by i7colors on 2020/1/15.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BannerModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(NSString *shopID);
@interface ShopArtistListCVCell : UICollectionViewCell
@property (nonatomic, copy) NSArray<BannerModel *> *artistShopArr;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
