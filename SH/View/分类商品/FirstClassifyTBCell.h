//
//  FirstClassifyTBCell.h
//  SH
//
//  Created by i7colors on 2019/9/16.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassifyModel;
NS_ASSUME_NONNULL_BEGIN

@interface FirstClassifyTBCell : UITableViewCell
@property (nonatomic, strong) ClassifyModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
