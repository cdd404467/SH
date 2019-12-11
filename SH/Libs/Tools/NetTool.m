//
//  NetTool.m
//  SH
//
//  Created by i7colors on 2019/9/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "NetTool.h"
#import "AFNetworking.h"


@implementation NetTool

//获取apiToken,先判断本地
+ (void)getApiTokenWithManager:(AFHTTPSessionManager * _Nonnull)manager Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    NSString *apiName = [NSString stringWithFormat:URLGet_Token_PhoneNumber,@"15516965560"];
    AFHTTPSessionManager *tokenManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:Server_Api]];
    tokenManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tokenManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [tokenManager GET:apiName parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        [UserDefault setObject:responseObject forKey:@"userToken"];
//        [manager.requestSerializer setValue:User_Token forHTTPHeaderField:@"Authorization"];
//        [self getRequestWithUrl:nil Params:nil Success:success Failure:failure manager:manager];
//        NSLog(@"222 ------   %@",User_Token);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取token失败  ---- %@",error);
    }];
}

//// Get请求
//+ (void)getRequest:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
//
//    NSURL *baseURL = [NSURL URLWithString:Server_Api];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
//    manager.requestSerializer.timeoutInterval = 10.0f;
//    //json序列化
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
////    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    [manager.requestSerializer setValue:[self getApiTokenFromNet:NO] forHTTPHeaderField:@"Authorization"];
//
//    //解决解析<null>崩溃
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
//    //发送Get请求
//    [manager GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NetModel *m = [NetModel mj_objectWithKeyValues:responseObject];
//        if (success) {
//            //json如果不是字典,万一是字典如果不包含code这个key的话，就返回json
//            if (![responseObject isKindOfClass:[NSDictionary class]] || ![[responseObject allKeys] containsObject:@"code"]) {
//                success(responseObject);
//            } else {
//                NSLog(@"msg----    %@",responseObject[@"msg"]);
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            NSLog(@"error----    %@",error);
//        }
//    }];
//}

// Get请求
+ (void)getRequest:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {

    NSURL *baseURL = [NSURL URLWithString:Server_Api];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer.timeoutInterval = 30.0f;
    //json序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:User_Token forHTTPHeaderField:@"Authorization"];
    //解决解析<null>崩溃
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [self getRequestWithUrl:requestUrl Params:params Success:success Failure:failure manager:manager];
}

+ (void)getRequestWithUrl:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure manager:(AFHTTPSessionManager *)manager {
//    NSLog(@"111 ------   %@",User_Token);
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
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            if (response.statusCode == 401) {
//                [self getApiTokenWithManager:manager Success:success Failure:failure];
            }
            NSLog(@"error----    %@",error);
        }
    }];

}

//post 请求
+ (void)postRequest:(NSString *)requestUrl Params:(id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {
    NSURL *baseURL = [NSURL URLWithString:Server_Api];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer.timeoutInterval = 30.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:User_Token forHTTPHeaderField:@"Authorization"];
    //解决解析<null>崩溃
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [self postRequestWithUrl:requestUrl Params:params Success:success Failure:failure manager:manager];
}

+ (void)postRequestWithUrl:(NSString *)requestUrl Params:(id)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure manager:(AFHTTPSessionManager *)manager {
    //发送Post请求
    [manager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            //json如果不是字典,万一是字典如果不包含code这个key的话，就返回json
            if (![responseObject isKindOfClass:[NSDictionary class]] || ![[responseObject allKeys] containsObject:@"code"]) {
                success(responseObject);
            } else {
                NSLog(@"msg ----   %@",responseObject[@"msg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            if (response.statusCode == 401) {
//                [self getApiTokenWithManager:manager Success:success Failure:failure];
            }
            NSLog(@"error 出错----    %@",error);
        }
    }];

}





+ (void)test {
    NSString *apiName = [NSString stringWithFormat:URLGet_Token_PhoneNumber,@"15516965560"];
    NSLog(@"apiName---  %@",apiName);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:Server_Api]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [manager GET:apiName parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        responseObject = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        [UserDefault setObject:responseObject forKey:@"userToken"];
        NSLog(@"---- %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"---- %@",error);
    }];
}









@end



@implementation NetModel

@end
