//
//  PayModel.h
//  SH
//
//  Created by i7colors on 2019/12/26.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeixinPayModel;
NS_ASSUME_NONNULL_BEGIN

@interface PayModel : NSObject
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) WeixinPayModel *pay;
@end

@interface WeixinPayModel : NSObject
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *signNew;
@property (nonatomic, assign) int timestamp;
@end
NS_ASSUME_NONNULL_END
