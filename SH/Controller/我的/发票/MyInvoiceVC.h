//
//  MyInvoiceVC.h
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"
@class InvoiceModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectInvoiceBlock)(InvoiceModel *model);
@interface MyInvoiceVC : BaseViewController
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) SelectInvoiceBlock selectInvoiceBlock;
@end

NS_ASSUME_NONNULL_END
