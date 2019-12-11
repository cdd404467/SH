//
//  SelectSpecView.h
//  SH
//
//  Created by i7colors on 2019/12/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDetailModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^JoinShopCarBlock)(NSInteger index, int buyCount);
typedef void(^BuyNowBlock)(NSInteger index, int buyCount);
typedef void(^CompleteBlock)(NSMutableDictionary *mDict);
@interface SelectSpecView : UIView
@property (nonatomic, strong) GoodsDetailModel *dataSource;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, copy) JoinShopCarBlock joinShopCarBlock;
@property (nonatomic, copy) BuyNowBlock buyNowBlock;
@property (nonatomic, copy) CompleteBlock completeBlock;
- (void)show;
@end

@interface SpecSecHeader : UICollectionReusableView
@property (nonatomic, copy) NSString *title;
@end

@interface SpecSecFooter : UICollectionReusableView

@end
NS_ASSUME_NONNULL_END
