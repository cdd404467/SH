//
//  BaseTableViewController.m
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageNumber = 1;
        _backBtn = self.mainNavController.backBtn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleTransition];
}

- (void)setBackBtnTintColor:(UIColor *)backBtnTintColor {
    _backBtnTintColor = backBtnTintColor;
    UIImage *image = [UIImage imageNamed:@"popBack"];
    [_backBtn setImage:[image imageWithTintColor:backBtnTintColor] forState:UIControlStateNormal];
    _backBtn.tintColor = backBtnTintColor;
}


- (void)setBackBtnBgColor:(UIColor *)backBtnBgColor {
    _backBtnBgColor = backBtnBgColor;
    _backBtn.backgroundColor = backBtnBgColor;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}



@end
