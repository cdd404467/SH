//
//  EvaluateModel.h
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EvaluateModel : NSObject
//评论者头像
@property (nonatomic, copy) NSString *headimgurl;
//评论内容
@property (nonatomic, copy) NSString *evaluateName;
//评论时间
@property (nonatomic, copy) NSString *gmtCreate;
//规格
@property (nonatomic, copy) NSString *skuName;
//评论者名字
@property (nonatomic, copy) NSString *userName;

@end

NS_ASSUME_NONNULL_END
