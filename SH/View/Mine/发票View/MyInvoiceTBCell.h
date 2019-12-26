//
//  MyInvoiceTBCell.h
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvoiceModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^EditBlock)(NSInteger index);
@interface MyInvoiceTBCell : UITableViewCell
@property (nonatomic, strong) InvoiceModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) EditBlock editBlock;
@end

NS_ASSUME_NONNULL_END
