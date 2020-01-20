//
//  NestWorksListViewVC.h
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NestWorksListViewVC : BaseViewController
@property (nonatomic, copy) void(^__nullable scrollCallback)(UIScrollView * scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *classifyID;
@property (nonatomic, strong) UINavigationController *nav;
@end

NS_ASSUME_NONNULL_END
