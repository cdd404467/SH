//
//  SceneDetailListView.h
//  SH
//
//  Created by i7colors on 2019/12/2.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface SceneDetailListView : UIView<JXPagerViewListViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) int sceneId;
@property (nonatomic, assign) NSInteger listType;
@property (nonatomic, strong) UINavigationController *nav;
@end

NS_ASSUME_NONNULL_END
