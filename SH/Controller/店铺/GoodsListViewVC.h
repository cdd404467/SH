//
//  GoodsListViewVC.h
//  SH
//
//  Created by i7colors on 2020/1/15.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "BaseViewController.h"
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsListViewVC : BaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) NSString *classifyID;
@property (nonatomic, strong) UINavigationController *nav;
@end

NS_ASSUME_NONNULL_END
