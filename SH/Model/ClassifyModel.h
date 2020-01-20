//
//  ClassifyModel.h
//  SH
//
//  Created by i7colors on 2019/9/16.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassifyModel : NSObject
//分类id
@property (nonatomic, copy) NSString *classifyID;
//分类名称
@property (nonatomic, copy) NSString *name;
//分类图片
@property (nonatomic, copy) NSString *img;

//一级分类下面的二级分类数组
@property (nonatomic, copy) NSArray *secondClassify;
@end

NS_ASSUME_NONNULL_END
