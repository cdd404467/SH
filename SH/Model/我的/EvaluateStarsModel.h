//
//  EvaluateStarsModel.h
//  SH
//
//  Created by i7colors on 2020/2/23.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EvaluateStarsModel : NSObject
//星星个数
@property (nonatomic, assign) NSInteger stars;
//评论文本
@property (nonatomic, copy) NSString *evaText;
//是否匿名发布
@property (nonatomic, assign) BOOL isAnonymous;
@end

NS_ASSUME_NONNULL_END
