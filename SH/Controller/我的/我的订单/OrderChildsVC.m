//
//  OrderChildsVC.m
//  SH
//
//  Created by i7colors on 2019/12/20.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderChildsVC.h"
#import "OrderListSectionHeader.h"
#import "OrderListSectionFooter.h"
#import "OrderListTBCell.h"
#import "NetTool.h"
#import "OrderModel.h"
#import <UIScrollView+EmptyDataSet.h>

@interface OrderChildsVC()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<OrderModel *> *dataSource;
@end

@implementation OrderChildsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.leftBtn.hidden = YES;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
//        _tableView.separatorColor = RGBA(222, 222, 222, 1);
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif + 20, 0);
    }
    return _tableView;
}

- (void)requestList {
    NSString *urlString = [NSString stringWithFormat:URLGet_Order_List,_orderType,PageCount,1];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        NSLog(@"----   %@",json);
        NSArray *tempArr = [OrderModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        for (OrderModel *model in tempArr) {
            model.orderDataList = [OrderGoodsModel mj_objectArrayWithKeyValuesArray:model.orderDataList];
        }
        [self.dataSource addObjectsFromArray:tempArr];
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {

    }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_order"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无相关订单";
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] orderDataList].count;
}
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OrderListSectionHeader *header = [OrderListSectionHeader headerWithTableView:tableView];
    header.model = self.dataSource[section];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    OrderListSectionFooter *footer = [OrderListSectionFooter footerWithTableView:tableView];
    footer.model = self.dataSource[section];
    return footer;
}

//// 设置 cell 是否允许左滑
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//// 设置默认的左滑按钮的title
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
//// 定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//// 点击左滑出现的删除按钮触发
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [Alert alertSystemTwo:@"是否确定删除该地址" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
//            [self deleteAddressWithIndex:indexPath.row];
//        }];
//    }
//}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTBCell *cell = [OrderListTBCell cellWithTableView:tableView];
    OrderModel *model = self.dataSource[indexPath.section];
    cell.model = model.orderDataList[indexPath.row];
    return cell;
}

@end
