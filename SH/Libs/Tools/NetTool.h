//
//  NetTool.h
//  SH
//
//  Created by i7colors on 2019/9/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingPort.h"
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetTool : NSObject
//+ (void)test;
+ (NSString *)getApiTokenFromNet:(BOOL)isGetFromNet;
//get请求
+ (void)getRequest:(NSString *)requestUrl Params:(NSDictionary * _Nullable)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;
//post请求


@end


@interface NetModel : NSObject
@property (nonatomic, copy) NSString *code;
@end
NS_ASSUME_NONNULL_END
