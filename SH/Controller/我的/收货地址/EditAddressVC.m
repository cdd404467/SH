//
//  EditAddressVC.m
//  SH
//
//  Created by i7colors on 2019/12/11.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "EditAddressVC.h"
#import "NetTool.h"
#import "AddressModel.h"

@interface EditAddressVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *receiverTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *detailAddressTF;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) AddressModel *dataSource;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UISwitch *defaultSwitch;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXColor(@"#F6F6F6", 1);
    self.navBar.title = self.editType == 0 ? @"新增收货地址" : @"编辑收货地址";
    [self.view addSubview:self.tableView];
    if (self.editType == 1) {
        [self requestData];
    }
    [self setupUI];
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"收件人",@"联系电话",@"收件地区",@"详细地址",@"设为默认", nil];
    }
    return _titleArray;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = HEXColor(@"#e6e6e6", 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [UIView new];
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    return _tableView;
}

- (void)setupUI {
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.layer.cornerRadius = 20.f;
    _saveBtn.clipsToBounds = YES;
    _saveBtn.adjustsImageWhenHighlighted = false;
    [_saveBtn addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-Bottom_Height_Dif - 8);
    }];
    [_saveBtn.superview layoutIfNeeded];
    [_saveBtn setBackgroundImage:[HelperTool globalGradientColor:_saveBtn.bounds] forState:UIControlStateNormal];
}

#pragma mark 请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Single_Address,_addressID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [AddressModel mj_objectWithKeyValues:json];
        self.receiverTF.text = self.dataSource.name;
        self.phoneTF.text = self.dataSource.phone;
        self.detailAddressTF.text = self.dataSource.address;
        self.addressLab.text = [NSString stringWithFormat:@"%@-%@-%@",self.dataSource.provinceName,self.dataSource.cityName,self.dataSource.districtName];
        self.defaultSwitch.on = self.dataSource.defaultStatus == 0 ? NO : YES;
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)saveAddress {
    
}

- (void)addSubmit {
//    NSDictionary *dict = @{@"name":_receiverTF.text,
//                           @"phone":_phoneTF.text,
//                           @"defaultStatus":@(_defaultSwitch.on == YES ? 1 : 0),
//                           @"provinceName": ,
//    };
//    
//    [NetTool postRequest:URLGet_Add_Address Params:dict Success:^(id  _Nonnull json) {
//        
//        NSLog(@"json---- %@",json);
//    } Failure:^(NSError * _Nonnull error) {
//        
//    }];
}

- (void)editSubmit {
    
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = HEXColor(@"#4A4A4A", 1);
    cell.textLabel.text = self.titleArray[indexPath.row];
    [self customCellWithCell:cell indexPath:indexPath];
    return cell;
}

- (void)customCellWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    if (index == 0 || index == 1 || index == 3) {
        UITextField *tf = [[UITextField alloc]init];
        tf.font = [UIFont systemFontOfSize:14];
        tf.textColor = HEXColor(@"#4A4A4A", 1);
        tf.tintColor = HEXColor(@"#FF5100", 1);
        [cell.contentView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(30 + KFit_W(70));
            make.right.mas_equalTo(-15);
        }];
        if (index == 0) {
            tf.placeholder = @"请输入收货人姓名";
            _receiverTF = tf;
        }
        else if (index == 1) {
            tf.placeholder = @"请输入收货人联系电话";
            _phoneTF = tf;
        }
        else if (index == 3) {
            tf.placeholder = @"街道楼牌号码";
            _detailAddressTF = tf;
        }
    }
    
    else if (index == 2) {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:14];
        _addressLab.textColor = HEXColor(@"#4A4A4A", 1);
        [cell.contentView addSubview:_addressLab];
        [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(30 + KFit_W(70));
            make.right.mas_equalTo(-15);
        }];
    } else if (index == 4) {
        _defaultSwitch = [[UISwitch alloc] init];
        _defaultSwitch.onTintColor = HEXColor(@"#FF5100", 1);
        _defaultSwitch.thumbTintColor = UIColor.whiteColor;
        [cell.contentView addSubview:_defaultSwitch];
        [_defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(24);
            make.centerY.mas_equalTo(cell.contentView);
        }];
    }
}

@end
