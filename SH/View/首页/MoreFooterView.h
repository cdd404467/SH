//
//  MoreFooterView.h
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomePageModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^PullBlock)(void);
@interface MoreFooterView : UICollectionReusableView
@property (nonatomic, strong) HomePageModel *model;
@property (nonatomic, copy) PullBlock pullBlock;
@end

NS_ASSUME_NONNULL_END
