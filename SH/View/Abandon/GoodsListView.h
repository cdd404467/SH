//
//  GoodsListView.h
//  SH
//
//  Created by i7colors on 2020/1/14.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsListView : UIView<JXPagerViewListViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *classifyID;
@property (nonatomic, strong) UINavigationController *nav;
@end

NS_ASSUME_NONNULL_END
