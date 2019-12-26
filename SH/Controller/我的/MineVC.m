//
//  MineVC.m
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MineVC.h"
#import "MinePageHeader.h"
#import "LoginVC.h"
#import "ShopCarVC.h"
#import "ReceiverAddressVC.h"
#import "MyInvoiceVC.h"
#import "SettingVC.h"
#import "MyOrdersVC.h"
#import "TempVC.h"



#import "PaySuccessVC.h"

@interface MineVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MinePageHeader *tableHeader;
@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray *imageArray;
@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"我的";
    self.navBar.backgroundColor = HEXColor(@"#333434", 1);
    self.navBar.titleLabel.textColor = UIColor.whiteColor;
    self.navBar.rightBtn.hidden = NO;
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"setting_icon"] forState:UIControlStateNormal];
    [self.navBar.rightBtn addTarget:self action:@selector(jumpToSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserInfo) name:NotificationName_UserLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserInfo) name:NotificationName_UserExitLogin object:nil];
    [self displayUserInfo];
}

#pragma mark - 初始化
- (MinePageHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[MinePageHeader alloc] init];
        [HelperTool addTapGesture:_tableHeader.headerImageView withTarget:self andSEL:@selector(headerClick)];
        [HelperTool addTapGesture:_tableHeader.nickNameLab withTarget:self andSEL:@selector(headerClick)];
        DDWeakSelf;
        _tableHeader.btnClickBlock = ^(NSInteger type) {
            if (!Get_User_Token) {
                [weakself jumpToLoginWithComplete:nil];
                return;
            }
            if (type == 0) {
                MyOrdersVC *vc = [[MyOrdersVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
            else {
                TempVC *vc = [[TempVC alloc] init];
                vc.type = type;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    
    return _tableHeader;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSMutableArray *sec_1 = [NSMutableArray arrayWithArray:@[@"购物车",@"收货地址",@"我的发票"]];
//        NSMutableArray *sec_1 = [NSMutableArray arrayWithArray:@[@"购物车",@"收货地址",@"我的发票",@"我的收藏"]];
//        NSMutableArray *sec_2 = [NSMutableArray arrayWithArray:@[@"成为设计师",@"成为商家"]];
//        NSMutableArray *sec_3 = [NSMutableArray arrayWithArray:@[@"联系客服"]];
        _titleArray = [NSMutableArray arrayWithCapacity:0];
        [_titleArray addObject:sec_1];
//        [_titleArray addObject:sec_2];
//        [_titleArray addObject:sec_3];
    }
    return _titleArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        NSMutableArray *sec_1 = [NSMutableArray arrayWithArray:@[@"cell_icon_shopcar",@"cell_icon_address",@"cell_icon_invoice"]];
//        NSMutableArray *sec_1 = [NSMutableArray arrayWithArray:@[@"cell_icon_shopcar",@"cell_icon_address",@"cell_icon_invoice",@"cell_icon_collect"]];
//        NSMutableArray *sec_2 = [NSMutableArray arrayWithArray:@[@"cell_icon_becomeDesigner",@"cell_icon_becomeSeller"]];
//        NSMutableArray *sec_3 = [NSMutableArray arrayWithArray:@[@"cell_icon_contactKF"]];
        _imageArray = [NSMutableArray arrayWithCapacity:0];
        [_imageArray addObject:sec_1];
//        [_imageArray addObject:sec_2];
//        [_imageArray addObject:sec_3];
    }
    return _imageArray;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:SCREEN_BOUNDS style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _tableView.separatorColor = HEXColor(@"#e1e1e1", 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.rowHeight = 50.f;
        _tableView.bounces = NO;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, TABBAR_HEIGHT + 20, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.tableHeaderView = self.tableHeader;
    }
    return _tableView;
}

- (void)headerClick {
    if (!Get_User_Token) {
        [self jumpToLoginWithComplete:nil];
        return;
    }
}

//跳转到设置
- (void)jumpToSetting {
    SettingVC *vc = [[SettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//显示信息
- (void)displayUserInfo {
    if (Get_User_Token) {
        NSString *headerUrl = [User_Info objectForKey:@"headimgurl"];
        [_tableHeader.headerImageView sd_setImageWithURL:ImgUrl_SD_OSS(headerUrl, 64)];
        
        NSString *name = [User_Info objectForKey:@"nickname"];
        _tableHeader.nickNameLab.text = name;
    } else {
        _tableHeader.nickNameLab.text = @"立即登录";
        _tableHeader.headerImageView.image = PlaceHolderImg;
    }
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray[section] count];
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!Get_User_Token) {
        [self jumpToLoginWithComplete:nil];
        return;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                ShopCarVC *vc = [[ShopCarVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                ReceiverAddressVC *vc = [[ReceiverAddressVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                MyInvoiceVC *vc = [[MyInvoiceVC alloc] init];
//                PaySuccessVC *vc = [[PaySuccessVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
