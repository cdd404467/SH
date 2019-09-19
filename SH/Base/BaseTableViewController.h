//
//  BaseTableViewController.h
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHLNavigation.h"
#import "UITableViewController+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UITableViewController
//有tableView的页面用到的属性
@property (nonatomic, assign)int pageNumber;
@property (nonatomic, assign)int totalNumber;

//nav 返回按钮的
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UIColor *backBtnTintColor;
@property (nonatomic, strong)UIColor *backBtnBgColor;
@end

NS_ASSUME_NONNULL_END
