//
//  HtmlStringTBCell.h
//  SH
//
//  Created by i7colors on 2019/11/26.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDetailModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^CellHeightBlock)(void);
@interface HtmlStringTBCell : UITableViewCell
@property (nonatomic, strong) GoodsDetailModel *model;
@property (nonatomic, copy)CellHeightBlock cellHeightBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign) CGFloat height;
@end

NS_ASSUME_NONNULL_END
