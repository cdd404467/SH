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
@end

@implementation GoodsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"商品详情";
    [self.view addSubview:self.tableView];
    
    HtmlStringTBCell *cell = [HtmlStringTBCell cellWithTableView:self.tableView];
    self.tempCellArray = [NSMutableArray arrayWithObject:cell];
    
//    [LoaderPlaceholder addLoaderToTargetView:self.tableView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [LoaderPlaceholder removeLoaderFromTargetView:self.tableView];
//    });
    
    [self requestData];
    [self requestEva];
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
            [weakself.specView show];
        };
        self.tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}

- (void)setupUI {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    
    CGFloat leftWidth = KFit_W(50);
    CGFloat rightWidth = (SCREEN_WIDTH - leftWidth * 3) / 2;
    NSArray *titleArr = @[@"分享",@"购物车",@"收藏"];
    NSArray *imgArr = @[@"goods_share",@"goods_icon_shopCar",@"collect_normal"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * leftWidth, 0, leftWidth, 49);
        [btn setTitleColor:HEXColor(@"#353535", 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        btn.backgroundColor = UIColor.whiteColor;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        if (i == 1) {
            _shopCarBtn = btn;
        }
        if (i == 2) {
            [btn setImage:[UIImage imageNamed:@"collect_selected"] forState:UIControlStateSelected];
            _collectionBtn = btn;
        }
        [bottomView addSubview:btn];
        [btn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:2];
    }
    
    if (self.dataSource.isCollect == YES) {
        _collectionBtn.selected = YES;
    }
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(leftWidth * 3 + i * rightWidth, 0, rightWidth, 49);
        [bottomView addSubview:btn];
        if (i == 0) {
            [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
            btn.backgroundColor = HEXColor(@"#090203", 1);
        } else {
            [btn setTitle:@"立即购买" forState:UIControlStateNormal];
            NSArray *colors= @[HEXColor(@"#FE7900", 1),HEXColor(@"#FF5100", 1)];
            UIImage *image = [UIImage imageWithGradientColor:colors andRect:btn.bounds andGradientType:1];
            [btn addEventHandler:^{
                
            }];
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
}

#pragma mark 请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Goods_Details,_goodsID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        NSLog(@"----   %@",json);
        self.dataSource = [GoodsDetailModel mj_objectWithKeyValues:json];
        self.dataSource.specList = [SpecListModel mj_objectArrayWithKeyValuesArray:self.dataSource.specList];
        self.dataSource.skuList = [SkuListModel mj_objectArrayWithKeyValuesArray:self.dataSource.skuList];
        for (SpecListModel *model in self.dataSource.specList) {
            model.goodsSkuSpecVals = [GoodsSkuSpecValsModel mj_objectArrayWithKeyValuesArray:model.goodsSkuSpecVals];
        }
        //默认选择第一个
        for (NSInteger i = 0; i < self.dataSource.specList.count; i++) {
            SpecListModel *spModel = self.dataSource.specList[i];
            GoodsSkuSpecValsModel *skuModel = spModel.goodsSkuSpecVals.firstObject;
            [self.selectArray addObject:skuModel.goodsSkuSpecValName];
            skuModel.isSelected = YES;
        }
        [self.secDataSource replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"评价(%@)",self.dataSource.evaluateCount]];
        //设置选中的商品
        SkuListModel *model = self.dataSource.skuList[0];
        self.specDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.specDict setValue:model.goodsSkuName forKey:@"specTxt"];
        [self.specDict setValue:model.goodsSkuImg forKey:@"specImg"];
        self.headerView.specValue = self.specDict;
        self.headerView.model = self.dataSource;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView cellForRowAtIndexPath:indexPath];
        [self.tableView reloadData];
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//加入购物车
- (void)joinShopCarWithIndex:(NSInteger)index count:(int)count {
    
    SkuListModel *model = self.dataSource.skuList[index];
    NSDictionary *dict = @{@"goodsId":@(model.goodsId),
                           @"skuId":@(model.skuId),
                           @"goodsNum":@(count)
    };
//    NSLog(@"dict ---- %@",params);
    
    [NetTool postRequest:URLPost_Add_ShopCar Params:dict Success:^(id  _Nonnull json) {
        
        NSLog(@"json---- %@",json);
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//获取评价
- (void)requestEva {
    NSString *urlString = [NSString stringWithFormat:URLGet_Goods_Evaluation,_goodsID,PageCount,1];
    //    NSLog(@"urlString ------  %@",urlString);
        [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//            NSLog(@"----   %@",json);
            
        } Failure:^(NSError * _Nonnull error) {
            
        }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 140;
    } else if (indexPath.section == 1) {
        return 130;
    } else {
//        return 500;
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
    switch (section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            header.showMoreBtn = NO;
            header.showLine = NO;
        }
            
            break;
        case 2:
        {
            header.showLine = NO;
            header.showMoreBtn = NO;
        }
            break;
        default:
            break;
    }
    return header;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EvaluationTBCell *cell = [EvaluationTBCell cellWithTableView:tableView];
        
        return cell;
    } else if (indexPath.section == 1) {
        ShopTBCell *cell = [ShopTBCell cellWithTableView:tableView];
        
        return cell;
    } else {
        HtmlStringTBCell *cell = self.tempCellArray[indexPath.row];
        cell.model = self.dataSource;
        DDWeakSelf;
        cell.cellHeightBlock = ^{
            [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:2], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
}

@end
