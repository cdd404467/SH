//
//  InvoiceDetailTBCell.h
//  SH
//
//  Created by i7colors on 2020/1/2.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceDetailTBCell : UITableViewCell
@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UILabel *rightLab;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
