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
#import <BRPickerView.h>
#import "UITextField+Limit.h"
#import "CddHud.h"

@interface EditAddressVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *receiverTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *detailAddressTF;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) AddressModel *dataSource;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UISwitch *defaultSwitch;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, copy) NSArray *addressDataSource;
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressDataSource = [self getAddressDataSource];
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
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
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
        self.addressTF.text = [NSString stringWithFormat:@"%@-%@-%@",self.dataSource.provinceName,self.dataSource.cityName,self.dataSource.districtName];
        self.defaultSwitch.on = self.dataSource.defaultStatus == 0 ? NO : YES;
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)saveAddress {
    if (_editType == 0) {
        [self addSubmit];
    } else if (_editType == 1) {
        [self editSubmit];
    }
}

- (void)addSubmit {
    if (![self judgeInfo]) {
        return;
    }
    __block MBProgressHUD *hud = [CddHud show:self.view];
    self.tableView.userInteractionEnabled = NO;
    self.saveBtn.userInteractionEnabled = NO;
    NSArray *arr = [self.addressTF.text componentsSeparatedByString:@"-"];
    NSDictionary *dict = @{@"name":_receiverTF.text,
                           @"phone":_phoneTF.text,
                           @"defaultStatus":@(_defaultSwitch.on == YES ? 1 : 0),
                           @"provinceName": arr[0],
                           @"cityName": arr[1],
                           @"districtName": arr[2],
                           @"address": _detailAddressTF.text
    };
    
    [NetTool postRequest:URLPost_Add_Address Params:dict Success:^(id  _Nonnull json) {
        [CddHud showSwitchText:hud text:@"保存成功"];
        self.tableView.userInteractionEnabled = YES;
        self.saveBtn.userInteractionEnabled = YES;
        if (self.saveSuccessBlock) {
            self.saveSuccessBlock();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } Error:^(id  _Nullable json) {
        
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)editSubmit {
    if (![self judgeInfo]) {
        return;
    }
    __block MBProgressHUD *hud = [CddHud show:self.view];
    self.tableView.userInteractionEnabled = NO;
    self.saveBtn.userInteractionEnabled = NO;
    NSArray *arr = [self.addressTF.text componentsSeparatedByString:@"-"];
    NSDictionary *dict = @{@"id":@(_addressID),
                           @"name":_receiverTF.text,
                           @"phone":_phoneTF.text,
                           @"defaultStatus":@(_defaultSwitch.on == YES ? 1 : 0),
                           @"provinceName": arr[0],
                           @"cityName": arr[1],
                           @"districtName": arr[2],
                           @"address": _detailAddressTF.text
    };
    [NetTool putRequest:URLPut_Update_Address Params:dict Success:^(id  _Nonnull json) {
        [CddHud showSwitchText:hud text:@"修改成功"];
        self.tableView.userInteractionEnabled = YES;
        self.saveBtn.userInteractionEnabled = YES;
        if (self.saveSuccessBlock) {
            self.saveSuccessBlock();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } Error:nil Failure:^(NSError * _Nonnull error) {

    }];
}


- (BOOL)judgeInfo {
    if (_receiverTF.text.length < 1) {
        [CddHud showTextOnly:@"请输入收货人名字" view:self.view];
        return NO;
    } else if (_phoneTF.text.length == 0) {
        [CddHud showTextOnly:@"请填写手机号" view:self.view];
        return NO;
    } else if (_phoneTF.text.length < 11) {
        [CddHud showTextOnly:@"请填写正确的手机号" view:self.view];
        return NO;
    } else if (_phoneTF.text.length > 1 && [_phoneTF.text substringToIndex:1].intValue != 1) {
        [CddHud showTextOnly:@"请填写正确的手机号" view:self.view];
        return NO;
    } else if (_addressTF.text.length < 3) {
        [CddHud showTextOnly:@"请选择收件地区" view:self.view];
        return NO;
    } else if (_detailAddressTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入收件详细地址" view:self.view];
        return NO;
    } else if (_detailAddressTF.text.length < 5) {
        [CddHud showTextOnly:@"收件地址不少于5个字" view:self.view];
        return NO;
    }
    return YES;
}


//地址选择
- (void)showPickView_area {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]initWithPickerMode:BRAddressPickerModeArea];
    addressPickerView.title = @"请选择地区";
    addressPickerView.dataSourceArr = self.addressDataSource;
    //addressPickerView.defaultSelectedArr = [self.infoModel.addressStr componentsSeparatedByString:@" "];
//    addressPickerView.selectIndexs = self.addressSelectIndexs;
//    addressPickerView.isAutoSelect = YES;
    DDWeakSelf;
    addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        weakself.addressTF.text = [NSString stringWithFormat:@"%@-%@-%@",province.fullName,city.fullName,area.fullName];
    };
    
    // 自定义弹框样式（适配深色模式）
    BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
    addressPickerView.pickerStyle = customStyle;
    [addressPickerView show];
}

- (NSArray *)getAddressDataSource {
    // 加载地区数据源（实际开发中这里可以写网络请求，从服务端请求数据。可以把 BRCity.json 文件的数据放到服务端去维护，通过接口获取这个数据源数组）
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return dataSource;
}


#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self showPickView_area];
    }
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
    if (index != 4) {
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
            tf.maxLength = 10;
            _receiverTF = tf;
        }
        else if (index == 1) {
            tf.placeholder = @"请输入收货人联系电话";
            tf.keyboardType = UIKeyboardTypeNumberPad;
            tf.maxLength = 11;
            _phoneTF = tf;
        }
        else if (index == 2) {
            tf.placeholder = @"省市区县、乡镇等";
            tf.userInteractionEnabled = false;
            tf.maxLength = 30;
            _addressTF = tf;
        }
        else if (index == 3) {
            tf.placeholder = @"街道楼牌号码";
            tf.maxLength = 50;
            _detailAddressTF = tf;
        }
    }
    else if (index == 4) {
        _defaultSwitch = [[UISwitch alloc] init];
        _defaultSwitch.onTintColor = HEXColor(@"#FF5100", 1);
        _defaultSwitch.thumbTintColor = UIColor.whiteColor;
        [cell.contentView addSubview:_defaultSwitch];
        [_defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(24);
            make.centerY.mas_equalTo(cell.contentView);
        }];
    }
}

@end
