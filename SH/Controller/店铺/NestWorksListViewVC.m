//
//  NestWorksListViewVC.m
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "NestWorksListViewVC.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ArtistWorksTBCell.h"
#import "NetTool.h"
#import "ArtistWorksModel.h"
#import "ArtistWorksDetailsVC.h"

@interface NestWorksListViewVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation NestWorksListViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self requestList];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 100) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    return _tableView;
}

- (void)requestList {
    NSString *urlString = [NSString stringWithFormat:URLGet_ArtistShop_WorksList,_classifyID];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
//        NSLog(@"------ %@",json);
        NSArray *tempArr = [ArtistWorksModel mj_objectArrayWithKeyValuesArray:json];
//        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:tempArr];
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"暂无作品~";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName:HEXColor(@"#999999", 1)
//                                 };
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}
//
//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    return UIColor.whiteColor;
//}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KFit_W(220) + 75 + 16;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistWorksModel *model = self.dataSource[indexPath.row];
    ArtistWorksDetailsVC *vc = [[ArtistWorksDetailsVC alloc] init];
    vc.worksID = model.worksID;
    [self.nav pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistWorksTBCell *cell = [ArtistWorksTBCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


- (void)dealloc {
    self.scrollCallback = nil;
}
@end
