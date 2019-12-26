//
//  OrderListSectionHeader.h
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

NS_ASSUME_NONNULL_BEGIN

@interface OrderListSectionHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) OrderModel *model;
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
