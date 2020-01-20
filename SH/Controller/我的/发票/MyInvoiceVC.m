//
//  MyInvoiceVC.m
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MyInvoiceVC.h"
#import "NetTool.h"
#import "InvoiceModel.h"
#import "MyInvoiceTBCell.h"
#import "EditInvoiceVC.h"
#import "Alert.h"
#import "CddHud.h"
#import <UIScrollView+EmptyDataSet.h>

@interface MyInvoiceVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *addInvoiceBtn;

@end

@implementation MyInvoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_navTitle) {
        self.navBar.title = _navTitle;
    } else {
        self.navBar.title = @"我的发票";
    }
    [self.view addSubview:self.tableView];
    [self requestData];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 7) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.bounces = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = RGBA(222, 222, 222, 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
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

#pragma mark 请求数据
- (void)requestData {
    [NetTool getRequest:URLGet_Invoice_List Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [InvoiceModel mj_objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//删除地址
- (void)deleteInvoiceWithIndex:(NSInteger)index {
    [CddHud show:self.view];
    InvoiceModel *model = self.dataSource[index];
    NSDictionary *dict = @{@"id":model.invoiceID,
    };
    self.tableView.userInteractionEnabled = NO;
    [NetTool putRequest:URLPut_Delete_Invoice Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        self.tableView.userInteractionEnabled = YES;
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } Error:nil Failure:^(NSError * _Nonnull error) {

    }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_invoice"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无发票信息";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#999999", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return UIColor.whiteColor;
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InvoiceModel *model = self.dataSource[indexPath.row];
    if (self.selectInvoiceBlock) {
        self.selectInvoiceBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 设置 cell 是否允许左滑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 设置默认的左滑按钮的title
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 点击左滑出现的删除按钮触发
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Alert alertSystemTwo:@"是否确定删除该发票?" msg:nil cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
            [self deleteInvoiceWithIndex:indexPath.row];
        }];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInvoiceTBCell *cell = [MyInvoiceTBCell cellWithTableView:tableView];
    cell.index = indexPath.row;
    cell.model = self.dataSource[indexPath.row];
    DDWeakSelf;
    cell.editBlock = ^(NSInteger index) {
        EditInvoiceVC *vc = [[EditInvoiceVC alloc] init];
        InvoiceModel *model = weakself.dataSource[indexPath.row];
        vc.invoiceID = model.invoiceID;
        vc.editType = 1;
        vc.model = model;
        vc.saveSuccessBlock = ^{
            [weakself requestData];
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)addNewInvoice {
    EditInvoiceVC *vc = [[EditInvoiceVC alloc] init];
    vc.editType = 0;
    DDWeakSelf;
    vc.saveSuccessBlock = ^{
        [weakself requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setupUI {
    _addInvoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addInvoiceBtn.layer.cornerRadius = 20.f;
    _addInvoiceBtn.clipsToBounds = YES;
    _addInvoiceBtn.adjustsImageWhenHighlighted = false;
    [_addInvoiceBtn addTarget:self action:@selector(addNewInvoice) forControlEvents:UIControlEventTouchUpInside];
    [_addInvoiceBtn setTitle:@"新增发票" forState:UIControlStateNormal];
    [_addInvoiceBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _addInvoiceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_addInvoiceBtn];
    [_addInvoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-Bottom_Height_Dif - 8);
    }];
    [_addInvoiceBtn.superview layoutIfNeeded];
    [_addInvoiceBtn setBackgroundImage:[HelperTool globalGradientColor:_addInvoiceBtn.bounds] forState:UIControlStateNormal];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

@end
