//
//  ReceiveAddressTBCell.h
//  SH
//
//  Created by i7colors on 2019/12/11.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^EditBlock)(NSInteger index);
@interface ReceiveAddressTBCell : UITableViewCell
@property (nonatomic, strong) AddressModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) EditBlock editBlock;
@end

NS_ASSUME_NONNULL_END
