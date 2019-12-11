//
//  SceneDetailHeaderView.h
//  SH
//
//  Created by i7colors on 2019/11/20.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickJumpBlock)(NSString *sceneID);
@interface SceneDetailHeaderView : UIView

@property (nonatomic, copy) NSString *bannerURL;
@property (nonatomic, copy) NSArray *iconArray;
@property (nonatomic, copy) ClickJumpBlock clickJumpBlock;
@end

NS_ASSUME_NONNULL_END
