//
//  SceneView.h
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SceneModel;

NS_ASSUME_NONNULL_BEGIN

@interface SceneView : UIView

@property (nonatomic, strong) SceneModel *model;
@end

NS_ASSUME_NONNULL_END
