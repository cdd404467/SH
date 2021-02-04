//
//  EvaluateVC.m
//  SH
//
//  Created by i7colors on 2020/2/23.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "EvaluateVC.h"
#import "EvaluateTBCell.h"
#import "EvaluateStarsModel.h"

@interface EvaluateVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<EvaluateStarsModel *> *dataSource;
@end

@implementation EvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"评价";
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < 10; i++) {
            EvaluateStarsModel *model = [[EvaluateStarsModel alloc] init];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 56) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _tableView.rowHeight = 305;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    }
    return _tableView;
}


#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaluateTBCell *cell = [EvaluateTBCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
