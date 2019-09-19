//
//  GoodsDetailsSectionHeader.h
//  SH
//
//  Created by i7colors on 2019/9/19.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickMoreBlock)(void);
@interface GoodsDetailsSectionHeader : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy)ClickMoreBlock clickMoreBlock;
@property (nonatomic, assign) BOOL showMoreBtn;
@property (nonatomic, assign) BOOL showLine;
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
