//
//  OrderDetailInfoTBCell.h
//  SH
//
//  Created by i7colors on 2019/12/31.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailInfoTBCell : UITableViewCell
@property (nonatomic, strong) UILabel *LeftLab;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) NSInteger disType;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
