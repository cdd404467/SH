//
//  MaterialModel.h
//  SH
//
//  Created by i7colors on 2019/9/22.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaterialModel : NSObject
//素材id
@property (nonatomic, copy) NSString *materialId;
//素材图片
@property (nonatomic, copy) NSString *logo;
//素材名称
@property (nonatomic, copy) NSString *name;
//素材介绍
@property (nonatomic, copy) NSString *detail;
//价格
@property (nonatomic, copy) NSString *price;
//是否收藏
@property (nonatomic, assign) BOOL isCollect;
//标签列表
@property (nonatomic, copy) NSArray *labelInfoList;
//设计师id
@property (nonatomic, copy) NSString *designerId;


/*** 详情 ***/
//视频地址
@property (nonatomic, copy) NSString *video;
//第一帧图片
@property (nonatomic, copy) NSString *videoImg;
//详情图片
@property (nonatomic, copy) NSString *richText;

@end



NS_ASSUME_NONNULL_END
