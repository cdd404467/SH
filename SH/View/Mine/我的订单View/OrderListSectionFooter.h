//
//  OrderListSectionFooter.h
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^LeftBtnClickBlock)(NSInteger type, NSInteger section);
typedef void(^RightBtnClickBlock)(NSInteger type, NSInteger section);
typedef void(^DetailClickBlock)(NSInteger section);
@interface OrderListSectionFooter : UITableViewHeaderFooterView
@property (nonatomic, strong) OrderModel *model;
+ (instancetype)footerWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) LeftBtnClickBlock leftBtnClickBlock;
@property (nonatomic, copy) RightBtnClickBlock rightBtnClickBlock;
@property (nonatomic, copy) DetailClickBlock detailClickBlock;
@property (nonatomic, assign) NSInteger section;
@end

NS_ASSUME_NONNULL_END
