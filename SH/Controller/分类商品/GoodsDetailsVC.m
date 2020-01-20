//
//  GoodsDetailsVC.m
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "GoodsDetailsVC.h"
#import "GoodsDetailsHeaderView.h"
#import "NetTool.h"
#import "GoodsDetailsSectionHeader.h"
#import "EvaluationTBCell.h"
#import "LoaderPlaceholder.h"
#import "ShopTBCell.h"
#import "GoodsModel.h"
#import "UIButton+Extension.h"
#import "HtmlStringTBCell.h"
#import "SelectSpecView.h"
#import "CddHud.h"
#import "ShopCarVC.h"
#import "ConfirmOrderVC.h"
#import "EvaluateModel.h"
#import <PPBadgeView.h>
#import <WXApi.h>

@interface GoodsDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GoodsDetailsHeaderView *headerView;
@property (nonatomic, strong) GoodsDetailModel *dataSource;
@property (nonatomic, strong) UIButton *shopCarBtn;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) NSMutableArray<HtmlStringTBCell *> *tempCellArray;
@property (nonatomic, strong) NSMutableArray *secDataSource;
@property (nonatomic, strong) SelectSpecView *specView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableDictionary *specDict;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation GoodsDetailsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"商品详情";
    if([WXApi isWXAppInstalled]) {  //判断用户是否已安装微信App
        [self.navBar.rightBtn setImage:[UIImage imageNamed:@"goods_share"] forState:UIControlStateNormal];
        self.navBar.rightBtn.hidden = NO;
        [self.navBar.rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.tableView];
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    HtmlStringTBCell *cell = [HtmlStringTBCell cellWithTableView:self.tableView];
    self.tempCellArray = [NSMutableArray arrayWithObject:cell];
    
//    [LoaderPlaceholder addLoaderToTargetView:self.tableView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [LoaderPlaceholder removeLoaderFromTargetView:self.tableView];
//    });
    
    [self requestData];
}


- (NSMutableArray *)secDataSource {
    if (!_secDataSource) {
        _secDataSource = [NSMutableArray arrayWithObjects:@"评价(0)",@"店铺介绍",@"商品详情", nil];
    }
    return _secDataSource;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArray;
}

- (SelectSpecView *)specView {
    if (!_specView) {
        _specView = [[SelectSpecView alloc] init];
        _specView.dataSource = _dataSource;
        _specView.selectArray = self.selectArray;
        DDWeakSelf;
        //加入购物车
        _specView.joinShopCarBlock = ^(NSInteger index, int buyCount) {
            [weakself joinShopCarWithIndex:index count:buyCount];
        };
        //立即购买
        _specView.buyNowBlock = ^(NSInteger index, int buyCount) {
            [weakself.specView complete];
            SkuListModel *model = weakself.dataSource.skuList[index];
            NSDictionary *dict = @{@"id":@(model.goodsId),
                                   @"skuId":@(model.skuId),
                                   @"goodsNum":@(buyCount)
            };
            NSDecimalNumber *singlePrice = [NSDecimalNumber decimalNumberWithString:weakself.dataSource.goodsPrice];
            NSDecimalNumber *count = [NSDecimalNumber decimalNumberWithString:@(buyCount).stringValue];
            NSDecimalNumber *money = [singlePrice decimalNumberByMultiplyingBy:count];
            
            ConfirmOrderVC *vc = [[ConfirmOrderVC alloc] init];
            vc.isCarPay = NO;
            vc.isBargain = NO;
            vc.goodsInfoList = @[dict];
            vc.money = money.stringValue;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController pushViewController:vc animated:YES];
            });
        };
        //选中替换信息
        _specView.completeBlock = ^(NSMutableDictionary * _Nonnull mDict) {
            weakself.headerView.specValue = mDict;
        };
        
    }
    return _specView;
}


//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _tableView.sectionFooterHeight = 0.0001;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _headerView = [[GoodsDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH + 115 + 70)];
        DDWeakSelf;
        _headerView.selectBlock = ^{
            if (![weakself judgeLogin]) {
                return;
            }
            weakself.specView.btnCountType = 1;
            [weakself.specView show];
        };
        self.tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}

- (void)setupUI {
    [_bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    DDWeakSelf;
//    NSArray *titleArr = @[@"分享",@"购物车",@"收藏"];
    NSArray *titleArr = @[@"购物车",@"收藏"];
//    NSArray *imgArr = @[@"goods_share",@"goods_icon_shopCar",@"collect_normal"];
    NSArray *imgArr = @[@"goods_icon_shopCar",@"collect_normal"];
    CGFloat leftWidth = KFit_W(65);
    CGFloat rightWidth = (SCREEN_WIDTH - leftWidth * titleArr.count) / 2;
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * leftWidth, 0, leftWidth, 49);
        [btn setTitleColor:HEXColor(@"#353535", 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        btn.backgroundColor = UIColor.whiteColor;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        if (i == 0) {
            _shopCarBtn = btn;
            [_shopCarBtn addEventHandler:^{
                if (![weakself judgeLogin]) {
                    return;
                }
                ShopCarVC *vc = [[ShopCarVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }];
        }
        if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"collect_selected"] forState:UIControlStateSelected];
            _collectionBtn = btn;
            [self collectionBtnClickEvent];
        }
        [_bottomView addSubview:btn];
        [btn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:2];
    }
    
    if (self.dataSource.isCollect == YES) {
        _collectionBtn.selected = YES;
    }
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(leftWidth * titleArr.count + i * rightWidth, 0, rightWidth, 49);
        [_bottomView addSubview:btn];
        if (i == 0) {
            [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [btn addEventHandler:^{
                if (![weakself judgeLogin]) {
                    return;
                }
                weakself.specView.btnCountType = 2;
                [weakself.specView show];
            }];
            btn.backgroundColor = HEXColor(@"#090203", 1);
        } else {
            [btn setTitle:@"立即购买" forState:UIControlStateNormal];
            NSArray *colors= @[HEXColor(@"#FE7900", 1),HEXColor(@"#FF5100", 1)];
            UIImage *image = [UIImage imageWithGradientColor:colors andRect:btn.bounds andGradientType:1];
            [btn addEventHandler:^{
                if (![weakself judgeLogin]) {
                    return;
                }
                weakself.specView.btnCountType = 3;
                [weakself.specView show];
            }];
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
}

//判断收藏按钮应该绑定哪个事件
- (void)collectionBtnClickEvent {
    self.collectionBtn.selected = self.dataSource.isCollect;
    [_collectionBtn removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    if (_collectionBtn.selected) {
        [_collectionBtn addTarget:self action:@selector(cancelCollectGoods) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_collectionBtn addTarget:self action:@selector(collectGoods) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark 请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Goods_Details,_goodsID];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
        NSLog(@"----   %@",json);
        self.dataSource = [GoodsDetailModel mj_objectWithKeyValues:json];
        self.dataSource.specList = [SpecListModel mj_objectArrayWithKeyValuesArray:self.dataSource.specList];
        self.dataSource.skuList = [SkuListModel mj_objectArrayWithKeyValuesArray:self.dataSource.skuList];
        self.dataSource.evaluateList = [EvaluateModel mj_objectArrayWithKeyValuesArray:self.dataSource.evaluateList];
        for (SpecListModel *model in self.dataSource.specList) {
            model.goodsSkuSpecVals = [GoodsSkuSpecValsModel mj_objectArrayWithKeyValuesArray:model.goodsSkuSpecVals];
        }
        //评价数量
        [self.secDataSource replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"评价(%@)",self.dataSource.evaluateCount]];
        
        //详情页面设置选中的商品
        SkuListModel *model = self.dataSource.skuList[0];
        self.specDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.specDict setValue:model.goodsSkuName forKey:@"specTxt"];
        [self.specDict setValue:model.goodsSkuImg forKey:@"specImg"];
        self.headerView.specValue = self.specDict;
        self.headerView.model = self.dataSource;
        
        //弹出的商品选择view,默认选择第一个
        for (NSInteger i = 0; i < self.dataSource.specList.count; i++) {
            SpecListModel *spModel = self.dataSource.specList[i];
            GoodsSkuSpecValsModel *skuModel = spModel.goodsSkuSpecVals.firstObject;
            [self.selectArray addObject:skuModel.goodsSkuSpecValName];
            skuModel.isSelected = YES;
        }
        
        //html标签图片
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView cellForRowAtIndexPath:indexPath];
        [self.tableView reloadData];
        [self setupUI];
        [self requestShopCarNum];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//请求购物车数量
- (void)requestShopCarNum {
    [NetTool getRequest:URLGet_ShopCar_Num Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"num----   %@",json);
        [self.shopCarBtn pp_moveBadgeWithX:- (self.shopCarBtn.width / 3) Y:8];
        [self.shopCarBtn pp_addBadgeWithNumber:[json integerValue]];
    } Failure:^(NSError * _Nonnull error) {
                    
    }];
}

//分享
- (void)share {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if (_dataSource.bannerArray.count > 0) {
        [imageArray addObject:_dataSource.bannerArray[0]];
    }
    NSString *shareStr = [NSString stringWithFormat:@"https://static.shanghusm.com/staticPath/shanghu/productDetails?productDetailsId=%d",_goodsID];
    
//    NSString *shareStr = [NSString stringWithFormat:@"http://192.168.11.183:8088/staticPath/shanghu/productDetails?productDetailsId=%d",_goodsID];
    NSString *title = _dataSource.goodsName;
    [HelperTool shareSomething:imageArray urlStr:shareStr title:title text:nil];
}

- (BOOL)judgeLogin {
    DDWeakSelf;
    if (!Get_User_Token) {
        [self jumpToLoginWithComplete:^{
            [weakself requestData];
        }];
        return NO;
    }
    return YES;
}

//收藏
- (void)collectGoods {
    if (![self judgeLogin]) {
        return;
    }
    NSDictionary *dict = @{@"type":@1,
                           @"typeId":@(_dataSource.goodsId)
    };
    __block MBProgressHUD *hud = [CddHud show:self.view];
    [NetTool postRequest:URLPost_Collect Params:dict Success:^(id  _Nonnull json) {
        [CddHud showSwitchText:hud text:@"已收藏"];
//        NSLog(@"--- %@",json);
        self.dataSource.isCollect = YES;
        [self collectionBtnClickEvent];
    }Error:^(id  _Nullable json) {
        
    } Failure:^(NSError * _Nonnull error) {
        [CddHud hideHUD:self.view];
    }];
}

//取消收藏
- (void)cancelCollectGoods {
    if (![self judgeLogin]) {
        return;
    }
    NSDictionary *dict = @{@"type":@1,
                           @"typeId":@(_dataSource.goodsId)
    };
    __block MBProgressHUD *hud = [CddHud show:self.view];
    [NetTool putRequest:URLPut_Cancel_Collect Params:dict Success:^(id  _Nonnull json) {
        [CddHud showSwitchText:hud text:@"已取消收藏"];
//        NSLog(@"c--- %@",json);
        self.dataSource.isCollect = NO;
        [self collectionBtnClickEvent];
    } Error:nil Failure:^(NSError * _Nonnull error) {
        [CddHud hideHUD:self.view];
    }];
}

//加入购物车
- (void)joinShopCarWithIndex:(NSInteger)index count:(int)count {
    SkuListModel *model = self.dataSource.skuList[index];
    NSDictionary *dict = @{@"goodsId":@(model.goodsId),
                           @"skuId":@(model.skuId),
                           @"goodsNum":@(count)
    };
    
    __block MBProgressHUD *hud = [CddHud show:self.specView];
    [NetTool postRequest:URLPost_Add_ShopCar Params:dict Success:^(id  _Nonnull json) {
        [CddHud showSwitchText:hud text:@"添加成功~"];
//        NSLog(@"json ---- %@",json);
        [self requestShopCarNum];
        if ([json integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.specView complete];
            });
        }
    } Error:^(id  _Nullable json) {
        
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dataSource.evaluateList.count < 3) {
            return self.dataSource.evaluateList.count;
        }
        return 2;
    }
//    else if (section == 1) {
//        return 1;
//    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }
//    else if (indexPath.section == 1) {
//        return 130;
//    }
    else {
        return self.dataSource.cellHeight;
    }
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GoodsDetailsSectionHeader *header = [GoodsDetailsSectionHeader headerWithTableView:tableView];
    header.title = self.secDataSource[section];
    if (section == 0) {
        header.showMoreBtn = NO;
        if (self.dataSource.evaluateCount.integerValue > 0) {
            header.showLine = YES;
        } else {
            header.showLine = NO;
        }
    } else if (section == 1) {
        header.showLine = NO;
        header.showMoreBtn = NO;
    }
    
    return header;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EvaluationTBCell *cell = [EvaluationTBCell cellWithTableView:tableView];
        NSArray *tempArr = [NSArray array];
        if (self.dataSource.evaluateList.count < 3) {
            tempArr = self.dataSource.evaluateList;
        } else {
            tempArr = [self.dataSource.evaluateList subarrayWithRange:NSMakeRange(0, 2)];
        }
        cell.model = tempArr[indexPath.row];
        return cell;
    }
//    else if (indexPath.section == 1) {
//        ShopTBCell *cell = [ShopTBCell cellWithTableView:tableView];
//
//        return cell;
//    }
    else {
        HtmlStringTBCell *cell = self.tempCellArray[indexPath.row];
        cell.model = self.dataSource;
        DDWeakSelf;
        cell.cellHeightBlock = ^{
            [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
}

@end
