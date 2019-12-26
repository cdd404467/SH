//
//  InvoiceModel.h
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceModel : NSObject
//发票ID
@property (nonatomic, copy) NSString *invoiceID;
//发票抬头,1 个人 2 单位
@property (nonatomic, assign) int normalType;
//发票类型,1 普通发票 2 增值税专用发票
@property (nonatomic, assign) int invoiceType;
//发票抬头字符串
@property (nonatomic, copy) NSString *title;
//收款人手机号
@property (nonatomic, copy) NSString *mobile;
//发票内容
@property (nonatomic, copy) NSString *content;
//是否默认 0不是 1是
@property (nonatomic, assign) NSInteger defaultStatus;
//纳税人识别码
@property (nonatomic, copy) NSString *taxCode;
//注册地址
@property (nonatomic, copy) NSString *loginAddress;
//公司名称
@property (nonatomic, copy) NSString *enterpriseName;
//收票人地址
@property (nonatomic, copy) NSString *address;
//昵称
@property (nonatomic, copy) NSString *nickname;
//开户银行
@property (nonatomic, copy) NSString *bankName;
//银行账户
@property (nonatomic, copy) NSString *account;
@end

NS_ASSUME_NONNULL_END
