//
//  NetTool.m
//  SH
//
//  Created by i7colors on 2019/9/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "NetTool.h"
#import <AFNetworking.h>


@implementation NetTool

//获取apiToken,先判断本地
+ (NSString *)getApiTokenFromNet:(BOOL)isGetFromNet {
    NSString *apiName = [NSString stringWithFormat:URLGet_Token_PhoneNumber,@"17601389308"];
    //获取本地存储的apiToken
    __block NSString *userToken = [UserDefault objectForKey:@"userToken"];
    //创建信号
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //本地如果没有apiToken，就去后台请求
    if (!userToken || [userToken isEqualToString:@""] || isGetFromNet == YES) {
        NSURL *baseURL = [NSURL URLWithString:Server_Api];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        //将参数json序列化
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        [manager GET:apiName parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"----  %@",responseObject);
            if ([responseObject isKindOfClass:[NSString class] ]) {
                userToken = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                [UserDefault setObject:userToken forKey:@"userToken"];
                [UserDefault synchronize];
            }
            dispatch_semaphore_signal(semaphore);   //发送信号
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            userToken = @"noNetWork";     //不加这句话(代码)，在没网且本地没apiToken的时候，就boom了，很尴尬
            dispatch_semaphore_signal(semaphore);   //发送信号
        }];
    } else {
        dispatch_semaphore_signal(semaphore);   //发送信号
    }
    //没收到信号之前一直会卡在这里
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"-- %@",User_Token);
    return userToken;
}

// Get请求
+ (void)getRequest:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    NSURL *baseURL = [NSURL URLWithString:Server_Api];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer.timeoutInterval = 10.0f;
    //json序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:User_Token forHTTPHeaderField:@"Authorization"];
    //解决解析<null>崩溃
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    //发送Get请求
    [manager GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NetModel *m = [NetModel mj_objectWithKeyValues:responseObject];
        if (success) {
            //json如果不是字典,万一是字典如果不包含code这个key的话，就返回json
            if (![responseObject isKindOfClass:[NSDictionary class]] || ![[responseObject allKeys] containsObject:@"code"]) {
                success(responseObject);
            } else {
                NSLog(@"msg----    %@",responseObject[@"msg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"error----    %@",error);
        }
    }];
}


//+ (void)test {
//    NSString *apiName = [NSString stringWithFormat:URLGet_Token_PhoneNumber,@"17601389308"];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:Server_Api]];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
////    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//
////    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
////    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    [manager GET:apiName parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        responseObject = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//
//        NSLog(@"---- %@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"---- %@",error);
//    }];
//}

@end



@implementation NetModel

@end
