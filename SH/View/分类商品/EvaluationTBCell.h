//
//  EvaluationTBCell.h
//  SH
//
//  Created by i7colors on 2019/9/19.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaluateModel;
NS_ASSUME_NONNULL_BEGIN

@interface EvaluationTBCell : UITableViewCell
@property (nonatomic, strong) EvaluateModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
