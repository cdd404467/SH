//
//  ShopNestWorksChildVC.h
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "BaseViewController.h"
#import <JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShopNestWorksChildVC : BaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, copy) NSString *shopID;
@property (nonatomic, strong) UINavigationController *nav;
@end

NS_ASSUME_NONNULL_END
