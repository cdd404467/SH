//
//  EvaluateTBCell.h
//  SH
//
//  Created by i7colors on 2020/2/23.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaluateStarsModel;

NS_ASSUME_NONNULL_BEGIN
@interface EvaluateTBCell : UITableViewCell
@property (nonatomic, strong) EvaluateStarsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
