//
//  ExpressTBCell.h
//  SH
//
//  Created by i7colors on 2020/1/3.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpressModel;
NS_ASSUME_NONNULL_BEGIN

@interface ExpressTBCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) ExpressModel *model;
@property (nonatomic, assign) BOOL isLineHidden;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
