//
//  OrderListTBCell.h
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface OrderListTBCell : UITableViewCell
@property (nonatomic, strong) OrderGoodsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
