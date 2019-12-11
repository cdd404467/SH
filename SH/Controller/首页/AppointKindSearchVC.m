//
//  AppointKindSearchVC.m
//  SH
//
//  Created by i7colors on 2019/9/17.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "AppointKindSearchVC.h"
#import "SearchResultVC.h"
#import "SearchView.h"

@interface AppointKindSearchVC ()
@property (nonatomic, strong) SearchView *searchView;
@end

@implementation AppointKindSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = self.title;
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchView.searchTF becomeFirstResponder];
}

- (void)setupUI {
    SearchView *searchView = [[SearchView alloc] init];
    searchView.top = NAV_HEIGHT;
    searchView.searchTF.placeholder = self.title;
    DDWeakSelf;
    searchView.searchBlock = ^{
        [weakself jumpToResult];
    };
    [self.view addSubview:searchView];
    _searchView = searchView;
}


- (void)jumpToResult {
    [self.view endEditing:YES];
    SearchResultVC *vc = [[SearchResultVC alloc] init];
    vc.keyWords = self.searchView.searchTF.text;
    vc.type = _type;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
