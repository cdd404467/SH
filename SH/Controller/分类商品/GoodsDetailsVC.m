//
//  GoodsDetailsVC.m
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "GoodsDetailsVC.h"
#import "GoodsDetailsHeaderView.h"
#import "NetTool.h"
#import "GoodsDetailsSectionHeader.h"
#import "EvaluationTBCell.h"
#import "LoaderPlaceholder.h"
#import "ShopTBCell.h"

@interface GoodsDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GoodsDetailsHeaderView *headerView;
@end

@implementation GoodsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self.view addSubview:self.tableView];
    [LoaderPlaceholder addLoaderToTargetView:self.tableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LoaderPlaceholder removeLoaderFromTargetView:self.tableView];
    });
    
    [self requestData];
}



//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _tableView.sectionFooterHeight = 0.0001;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _headerView = [[GoodsDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH + 115)];
        self.headerView.imageArray = @[@"http://static1.pezy.cn/img/2019-02-01/5932241902444072231.jpg", @"http://static1.pezy.cn/img/2019-03-01/1206059142424414231.jpg"];
        self.tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}

#pragma mark 请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Goods_Details,_goodsID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
                        NSLog(@"----   %@",json);
        
        
        
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 140;
    } else if (indexPath.section == 1) {
        return 130;
    } else {
        return 140;
    }
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"评价 (18908)",@"店铺介绍",@"商品详情"];
    GoodsDetailsSectionHeader *header = [GoodsDetailsSectionHeader headerWithTableView:tableView];
    header.title = titleArr[section];
    switch (section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            header.showMoreBtn = NO;
            header.showLine = NO;
        }
            
            break;
        case 2:
        {
            header.showLine = NO;
            header.showMoreBtn = NO;
        }
            break;
        default:
            break;
    }
    return header;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EvaluationTBCell *cell = [EvaluationTBCell cellWithTableView:tableView];
        
        return cell;
    } else if (indexPath.section == 1) {
        ShopTBCell *cell = [ShopTBCell cellWithTableView:tableView];
        
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        return cell;
    }
}

@end
