//
//  SettingVC.m
//  SH
//
//  Created by i7colors on 2019/12/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SettingVC.h"
#import <UIImageView+WebCache.h>
#import "Alert.h"
#import "CddHud.h"
#import "CddActionSheetView.h"
#import "AboutUSVC.h"

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray *subTitleArray;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"设置";
    self.navBar.backgroundColor = Like_Color;
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSArray *arr = @[@[@"关于尚乎"],@[@"清除缓存"]];
        _titleArray = [NSMutableArray arrayWithArray:arr];
        if (Get_User_Token) {
            [_titleArray addObject:@[@"退出登录"]];
        }
    }
    return _titleArray;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = Like_Color;
        [_tableView setSeparatorColor : Line_Color];
        _tableView.bounces = NO;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

//清理缓存
- (void)clearCache {
    [Alert alertSystemTwo:@"是否确定清除缓存?" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
        __block MBProgressHUD *hud = [CddHud showWithText:@"清理中..." view:self.view];
        [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeDisk completion:^{
            [CddHud showSwitchText:hud text:@"清理完成!"];
        }];
    }];
}

//退出登录
- (void)exitLogin {
    NSString *title = @"确定要退出登录吗?";
    DDWeakSelf;
    CddActionSheetView *sheetView = [[CddActionSheetView alloc] initWithSheetOKTitle:@"退出登录" cancelTitle:@"取消" completion:^{
        if (Get_User_Token) {
            [UserDefault removeObjectForKey:@"userInfo"];
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_UserExitLogin object:nil userInfo:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } cancel:nil];
    sheetView.title = title;
    [sheetView show];
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
    return 15;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AboutUSVC *vc = [[AboutUSVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1) {
        [self clearCache];
    }
    else {
        [self exitLogin];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        if (indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
//    cell.detailTextLabel.text = self.subTitleArray[indexPath.section][indexPath.row];
    //控制显示箭头和文字位置
    if (indexPath.section == 2) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}
@end
