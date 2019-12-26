//
//  DesignerDynamicStateListView.m
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DesignerDynamicStateListView.h"
#import "DynamicStateTBCell.h"
#import "DesignerModel.h"
#import "MaterialDetailsVC.h"
#import <UIScrollView+EmptyDataSet.h>

@interface DesignerDynamicStateListView()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation DesignerDynamicStateListView
- (void)dealloc
{
    self.scrollCallback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif + 20, 0);
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_works"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无动态";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#999999", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return UIColor.whiteColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicStateModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicStateTBCell *cell = [DynamicStateTBCell cellWithTableView:tableView];
    DDWeakSelf;
    cell.clickBlock = ^(NSString * _Nonnull materialId) {
        MaterialDetailsVC *vc = [[MaterialDetailsVC alloc] init];
        vc.materialId = materialId;
        [weakself.nav pushViewController:vc animated:YES];
    };
    cell.model = self.dataSource[indexPath.row];
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    cell.textLabel.text = self.dataSource[indexPath.row];
//    NSLog(@"----------- %d",indexPath.row);
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listDidAppear {
//    NSLog(@"listDidAppear");
}

- (void)listDidDisappear {
//    NSLog(@"listDidDisappear");
}

@end
