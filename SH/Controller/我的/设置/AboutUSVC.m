//
//  AboutUSVC.m
//  SH
//
//  Created by i7colors on 2019/12/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "AboutUSVC.h"
#import "WebViewVC.h"

@interface AboutUSVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray *subTitleArray;
@end

@implementation AboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"关于尚乎";
    self.navBar.backgroundColor = Like_Color;
    [self.view addSubview:self.tableView];
    [self setupUI];
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSArray *arr = @[@[@"用户协议",@"商家协议"],@[@"版本"],];
        _titleArray = [NSMutableArray arrayWithArray:arr];
    }
    return _titleArray;
}

- (NSMutableArray *)subTitleArray {
    if (!_subTitleArray) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *current_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *version = [NSString stringWithFormat:@"V%@",current_Version];
        NSArray *arr = @[@[@"",@""],@[version]];
        _subTitleArray = [NSMutableArray arrayWithArray:arr];
    }
    return _subTitleArray;
}

- (void)setupUI {
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.frame = CGRectMake(0, self.tableView.height - Bottom_Height_Dif - 90, SCREEN_WIDTH, 80);
    copyrightLabel.numberOfLines = 2;
    copyrightLabel.text = @"Copyright © 2018\n尚乎shanghusm.com 版权所有";
    copyrightLabel.font = [UIFont systemFontOfSize:15];
    copyrightLabel.textColor = HEXColor(@"#868686", 1);
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:copyrightLabel];
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
        if (indexPath.row == 0) {
            WebViewVC *vc = [[WebViewVC alloc] init];
            vc.webUrl = @"http://static.shanghusm.com/personalPrivate.html";
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            WebViewVC *vc = [[WebViewVC alloc] init];
            vc.webUrl = @"http://static.shanghusm.com/userService.html";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
//    else if (indexPath.section == 1) {
//        [self clearCache];
//    }
//    else {
//        [self exitLogin];
//    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.text = self.subTitleArray[indexPath.section][indexPath.row];
    //控制显示箭头和文字位置
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
@end
