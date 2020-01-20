//
//  ShopNestWorksChildVC.m
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ShopNestWorksChildVC.h"
#import <JXCategoryTitleView.h>
#import "NestWorksListViewVC.h"
#import "UIView+Border.h"
#import "NetTool.h"
#import "ClassifyModel.h"

@interface ShopNestWorksChildVC ()<JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIScrollView *currentListView;
@property (nonatomic, strong) NSMutableArray<NestWorksListViewVC *> *vcArr;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@end

@implementation ShopNestWorksChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.leftBtn.hidden = YES;
    [self requestClassify];
}

- (NSMutableArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titlesArray;
}

- (NSMutableArray *)vcArr {
    if (!_vcArr) {
        _vcArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _vcArr;
}

- (void)setupUI {
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.categoryView.titles = self.titlesArray;
    self.categoryView.backgroundColor = UIColor.whiteColor;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = HEXColor(@"#FF5100", 1);
    self.categoryView.titleColor = HEXColor(@"#9B9B9B", 1);
    self.categoryView.titleColorGradientEnabled = YES;
    [self.view addSubview:self.categoryView];
//    [self.categoryView addBorder:Line_Color width:0.8 direction:BorderDirectionBottom];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    self.categoryView.contentScrollView = self.contentScrollView;
    
    DDWeakSelf;
    for (NSInteger i = 0; i < self.titlesArray.count; i++) {
        NestWorksListViewVC *vc = [[NestWorksListViewVC alloc] init];
        ClassifyModel *model = self.dataSource[i];
        vc.classifyID = model.classifyID;
        vc.nav = self.nav;
        vc.scrollCallback = ^(UIScrollView *scrollView) {
            weakself.scrollCallback(scrollView);
        };
        if (i == 0) {
            self.currentListView = vc.tableView;
        }
        [self.vcArr addObject:vc];
        [self.contentScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    
    
}

- (void)requestClassify {
    NSString *urlString = [NSString stringWithFormat:URLGet_ArtistShop_WorksClassifys,_shopID];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
//        NSLog(@"------- %@",json);
        self.dataSource = [ClassifyModel mj_objectArrayWithKeyValuesArray:json];
        for (ClassifyModel *model in self.dataSource) {
            [self.titlesArray addObject:model.name];
        }
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.contentScrollView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * self.titlesArray.count, self.contentScrollView.bounds.size.height);
    
    for (NSInteger i = 0; i < self.titlesArray.count; i++) {
        UIViewController *vc = self.vcArr[i];
        vc.view.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}


#pragma  mark - JXPagerViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.currentListView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //根据选中的下标，实时更新currentListView
    NestWorksListViewVC *vc = self.vcArr[index];
    self.currentListView = vc.tableView;
}
@end
