//
//  SceneModel.h
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SceneModel : NSObject
//场景图片
@property (nonatomic, copy) NSString *icon;
//场景名字
@property (nonatomic, copy) NSString *name;
//场景id
@property (nonatomic, copy) NSString *sceneId;
//场景描述
@property (nonatomic, copy) NSString *detail;
//场景缩略图
@property (nonatomic, copy) NSString *logo;

@end

NS_ASSUME_NONNULL_END
