//
//  BaseViewController.h
//  SH
//
//  Created by i7colors on 2019/9/2.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ViewController.h"
#import "VHLNavigation.h"
#import "UIViewController+Extension.h"


NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : ViewController
//有tableView的页面用到的属性
@property (nonatomic, assign)int pageNumber;
@property (nonatomic, assign)int totalNumber;
//返回按钮模式 - 0:返回箭头 1:关闭箭头
@property (nonatomic, assign) NSInteger backMode;

//nav 返回按钮的
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UIColor *backBtnTintColor;
@property (nonatomic, strong)UIColor *backBtnBgColor;
@end

NS_ASSUME_NONNULL_END
