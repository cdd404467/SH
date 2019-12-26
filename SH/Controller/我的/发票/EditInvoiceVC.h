//
//  EditInvoiceVC.h
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"
@class InvoiceModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^SaveSuccessBlock)(void);
@interface EditInvoiceVC : BaseViewController
//0是添加，1是编辑
@property (nonatomic, assign) int editType;
@property (nonatomic, copy) NSString *invoiceID;
@property (nonatomic, copy) SaveSuccessBlock saveSuccessBlock;
@property (nonatomic, strong) InvoiceModel *model;
@end

NS_ASSUME_NONNULL_END
