//
//  DesignerModel.h
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignerModel : NSObject
//设计师id
@property (nonatomic, copy) NSString *designerId;
//设计师名称
@property (nonatomic, copy) NSString *designerName;
//设计师图片
@property (nonatomic, copy) NSString *headimgurl;
//设计师等级
@property (nonatomic, assign) NSInteger level;
//设计师简介
@property (nonatomic, copy) NSString *detail;
//标签集合
@property (nonatomic, copy) NSString *labelNames;
//标签数组
@property (nonatomic, copy) NSArray *labelArray;
//素材数组
@property (nonatomic, copy) NSArray *materialList;


//
@property (nonatomic, assign) CGFloat cellHeight;

//详情增加的字段
@property (nonatomic, copy) NSString *img;
//昵称
@property (nonatomic, copy) NSString *nickname;

@end

@interface FinishedWorkModel : NSObject
//成品图片
@property (nonatomic, copy) NSString *works;
@end

@interface DynamicImgModel : NSObject
//时间戳
@property (nonatomic, copy) NSString *gmtCreate;
//图片
@property (nonatomic, copy) NSString *logo;
//素材ID
@property (nonatomic, copy) NSString *materialId;

@end

@interface DynamicStateModel : NSObject
//动态
@property (nonatomic, copy) NSArray *trendsList;
//年月
@property (nonatomic, copy) NSString *strDate;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
NS_ASSUME_NONNULL_END
