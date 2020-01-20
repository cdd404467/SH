//
//  ReceiverAddressVC.m
//  SH
//
//  Created by i7colors on 2019/12/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ReceiverAddressVC.h"
#import "ReceiveAddressTBCell.h"
#import "NetTool.h"
#import "AddressModel.h"
#import "EditAddressVC.h"
#import "Alert.h"
#import "CddHud.h"
#import <UIScrollView+EmptyDataSet.h>

@interface ReceiverAddressVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *addAddressBtn;

@end

@implementation ReceiverAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_navTitle) {
        self.navBar.title = _navTitle;
    } else {
        self.navBar.title = @"收货地址";
    }
    [self.view addSubview:self.tableView];
    [self requestData];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 7) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
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
    [NetTool getRequest:URLGet_Address_List Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [AddressModel mj_objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//删除地址
- (void)deleteAddressWithIndex:(NSInteger)index {
    [CddHud show:self.view];
    AddressModel *model = self.dataSource[index];
    NSDictionary *dict = @{@"id":@(model.addressID),
                           @"defaultStatus":@(model.defaultStatus),
    };
    self.tableView.userInteractionEnabled = NO;
    [NetTool putRequest:URLPut_Delete_Address Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        self.tableView.userInteractionEnabled = YES;
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } Error:nil Failure:^(NSError * _Nonnull error) {

    }];
}

- (void)setupUI {
    _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addAddressBtn.layer.cornerRadius = 20.f;
    _addAddressBtn.clipsToBounds = YES;
    _addAddressBtn.adjustsImageWhenHighlighted = false;
    [_addAddressBtn addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [_addAddressBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [_addAddressBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_addAddressBtn];
    [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-Bottom_Height_Dif - 8);
    }];
    [_addAddressBtn.superview layoutIfNeeded];
    [_addAddressBtn setBackgroundImage:[HelperTool globalGradientColor:_addAddressBtn.bounds] forState:UIControlStateNormal];
}

- (void)addNewAddress {
    EditAddressVC *vc = [[EditAddressVC alloc] init];
    vc.editType = 0;
    DDWeakSelf;
    vc.saveSuccessBlock = ^{
        [weakself requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_address"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"你还没有添加收货地址~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#999999", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return UIColor.whiteColor;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -100;
//}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressModel *model = self.dataSource[indexPath.row];
    if (self.selectAddressBlock) {
        self.selectAddressBlock(model);
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
        [Alert alertSystemTwo:@"是否确定删除该地址" msg:nil cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
            [self deleteAddressWithIndex:indexPath.row];
        }];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiveAddressTBCell *cell = [ReceiveAddressTBCell cellWithTableView:tableView];
    cell.index = indexPath.row;
    cell.model = self.dataSource[indexPath.row];
    DDWeakSelf;
    cell.editBlock = ^(NSInteger index) {
        EditAddressVC *vc = [[EditAddressVC alloc] init];
        vc.addressID = [weakself.dataSource[indexPath.row] addressID];
        vc.editType = 1;
        vc.saveSuccessBlock = ^{
            [weakself requestData];
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

@end
