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
//设计师头像
@property (nonatomic, copy) NSString *headimgurl;
//设计师头像
@property (nonatomic, assign) NSInteger level;
@end

NS_ASSUME_NONNULL_END
