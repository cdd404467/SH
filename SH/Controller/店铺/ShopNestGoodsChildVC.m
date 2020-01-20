//
//  ShopNestGoodsChildVC.m
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ShopNestGoodsChildVC.h"
#import <JXCategoryTitleView.h>
#import "NestGoodsListViewVC.h"
#import "UIView+Border.h"
#import "ShopModel.h"

@interface ShopNestGoodsChildVC ()<JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIScrollView *currentListView;
@property (nonatomic, strong) NSMutableArray<NestGoodsListViewVC *> *vcArr;
@property (nonatomic, strong) NSMutableArray *titlesArray;

@end

@implementation ShopNestGoodsChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.leftBtn.hidden = YES;
    for (ClassifyListModel *model in self.classifyArray) {
        [self.titlesArray addObject:model.name];
    }
    [self setupUI];
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
    [self.categoryView addBorder:Line_Color width:0.8 direction:BorderDirectionBottom];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    self.categoryView.contentScrollView = self.contentScrollView;
    
    DDWeakSelf;
    for (NSInteger i = 0; i < self.titlesArray.count; i++) {
        NestGoodsListViewVC *vc = [[NestGoodsListViewVC alloc] init];
        ClassifyListModel *model = self.classifyArray[i];
        vc.classifyID = model.classifyId;
        vc.nav = _nav;
        vc.scrollCallback = ^(UIScrollView *scrollView) {
            weakself.scrollCallback(scrollView);
        };
        if (i == 0) {
            self.currentListView = vc.collectionView;
        }
        [self.vcArr addObject:vc];
        [self.contentScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    
    
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
    NestGoodsListViewVC *vc = self.vcArr[index];
    self.currentListView = vc.collectionView;
}

@end
