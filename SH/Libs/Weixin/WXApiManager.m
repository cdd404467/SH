//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:WeixinPayResultSuccess object:resp];
                break;
                
            default:
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [[NSNotificationCenter defaultCenter] postNotificationName:WeixinPayResultFailed object:resp];
                break;
        }
    }else {
        
    }
}

- (void)onReq:(BaseReq *)req {

}

@end
