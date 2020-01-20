//
//  MyCollectionVC.m
//  SH
//
//  Created by i7colors on 2019/12/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MyCollectionVC.h"
#import <SGPagingView.h>
#import "CollectionChildVC.h"

@interface MyCollectionVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本

@end

@implementation MyCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"我的收藏";
    [self setupUI];
}

- (void)setupUI {
    CGFloat titleHeight = 40;
    NSArray *titleArr = @[@"商品",@"素材"];
    NSArray *typeArr = @[@"1",@"2"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:13];
    configure.titleColor = HEXColor(@"#9B9B9B", 1);
    configure.indicatorColor = HEXColor(@"#FF5100", 1);
    configure.indicatorAnimationTime = 0.3f;
    configure.showBottomSeparator = NO;
    configure.indicatorCornerRadius = 2.f;
    configure.titleSelectedColor = HEXColor(@"#FF5100", 1);
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, titleHeight);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.selectedIndex = 0;
    [self.view addSubview:_pageTitleView];
    
    NSMutableArray *childArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        CollectionChildVC *vc = [[CollectionChildVC alloc] init];
        vc.type = [typeArr[i] integerValue];
        [childArr addObject:vc];
    }
    
    CGRect contentRect = CGRectMake(0, titleHeight + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - -NAV_HEIGHT - titleHeight);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:contentRect parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollViewWillBeginDragging {
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    _pageTitleView.userInteractionEnabled = YES;
}

@end
