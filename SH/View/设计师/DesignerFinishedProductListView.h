//
//  DesignerFinishedProductListView.h
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignerFinishedProductListView : UIView<JXPagerViewListViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

NS_ASSUME_NONNULL_END
