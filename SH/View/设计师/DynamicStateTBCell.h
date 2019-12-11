//
//  DynamicStateTBCell.h
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DynamicStateModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(NSString *materialId);
@interface DynamicStateTBCell : UITableViewCell
@property (nonatomic, strong) DynamicStateModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
