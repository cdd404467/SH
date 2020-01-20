//
//  AddressDisplayTBCell.h
//  SH
//
//  Created by i7colors on 2019/12/30.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface AddressDisplayTBCell : UITableViewCell
@property (nonatomic, strong) OrderDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
