//
//  OrderGoodsTBCell.h
//  SH
//
//  Created by i7colors on 2019/12/13.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderGoodsModel;

NS_ASSUME_NONNULL_BEGIN

@interface OrderGoodsTBCell : UITableViewCell
@property (nonatomic, strong) OrderGoodsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
