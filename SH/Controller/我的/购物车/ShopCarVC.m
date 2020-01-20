//
//  ShopCarVC.m
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ShopCarVC.h"
#import "ShopCarCVCell.h"
#import "UIButton+Extension.h"
#import "NetTool.h"
#import "ShopCarSectionHeader.h"
#import <AFNetworking.h>
#import "ShopCarModel.h"
#import "CddHud.h"
#import "ConfirmOrderVC.h"
#import <UIScrollView+EmptyDataSet.h>


static NSString *shopCarCVID = @"ShopCarCVCell";
static NSString *sectionHeaderCVID = @"ShopCarSectionHeader";
@interface ShopCarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ShopCarModel *> *dataSource;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *totalPriceLab;
@property (nonatomic, strong) UIButton *settleAccountBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, copy) NSString *totalMoney;
@end

@implementation ShopCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"购物车";
    [self.view addSubview:self.collectionView];
    [self requestList];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCarData) name:NotificationName_RemoveCarHasSelectedGoods object:nil];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

//collectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH - 20, 116);
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.minimumLineSpacing = 0;
        layout.minimumLineSpacing = 0;
        CGRect rect = CGRectMake(0, NAV_HEIGHT + 40, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 40);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = MainBgColor;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0);
        [_collectionView registerClass:[ShopCarCVCell class] forCellWithReuseIdentifier:shopCarCVID];
        [_collectionView registerClass:[ShopCarSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderCVID];
    }
    return _collectionView;
}

- (void)changeCarData {
    [NetTool getRequest:URLGet_Shop_Car_List Params:nil Success:^(id  _Nonnull json) {
        self.dataSource = [ShopCarModel mj_objectArrayWithKeyValuesArray:json];
        for (ShopCarModel *model in self.dataSource) {
            model.carGoodsList = [ShopGoodsModel mj_objectArrayWithKeyValuesArray:model.carGoodsList];
        }
    self.selectAllBtn.selected = YES;
    [self selectAllGoods];
//        NSLog(@"----   %@",json);
    } Failure:^(NSError * _Nonnull error) {
                    
    }];
}

#pragma mark 请求数据
//购物车列表
- (void)requestList {
    [NetTool getRequest:URLGet_Shop_Car_List Params:nil Success:^(id  _Nonnull json) {
        self.dataSource = [ShopCarModel mj_objectArrayWithKeyValuesArray:json];
        for (ShopCarModel *model in self.dataSource) {
            model.carGoodsList = [ShopGoodsModel mj_objectArrayWithKeyValuesArray:model.carGoodsList];
        }
        [self.collectionView reloadData];
//        NSLog(@"----   %@",json);
    } Failure:^(NSError * _Nonnull error) {
                    
    }];
}

//修改car数量
- (void)changeShopCarWithNum:(NSInteger)num carID:(NSString *)carID type:(NSInteger)type indexPath:(NSIndexPath *)indexPath {
    [self.activityIndicator startAnimating];
    NSDictionary *dict = @{@"id":carID,
                           @"goodsNum":@(num),
    };
    [NetTool putRequest:URLPut_Change_ShopCar Params:dict Success:^(id  _Nonnull json) {
        [self.activityIndicator stopAnimating];
        ShopCarModel *md = self.dataSource[indexPath.section];
        ShopGoodsModel *model = md.carGoodsList[indexPath.row];
        if (type == 1) {
            model.goodsNum = ++model.goodsNum;
        } else {
            model.goodsNum = --model.goodsNum;
        }
        [self countMoney];
        [self.collectionView reloadData];
    } Error:nil Failure:^(NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
    }];
}

//删除商品
- (void)deleteGoods {
    [self.activityIndicator startAnimating];
    NSDictionary *dict = @{@"idList":[self getGoodsListWillDelete],
    };
    
    [NetTool putRequest:URLPut_Delete_ShopCar Params:dict Success:^(id  _Nonnull json) {
        [self.activityIndicator stopAnimating];
        //这里一边遍历一边删除逆序操作
        for (ShopCarModel *shopModel in self.dataSource.reverseObjectEnumerator) {
            if (shopModel.isSelected) {
                [self.dataSource removeObject:shopModel];
                continue;
            }
            for (ShopGoodsModel *goodsModel in shopModel.carGoodsList.reverseObjectEnumerator) {
                if (goodsModel.isSelected) {
                    [shopModel.carGoodsList removeObject:goodsModel];
                }
            }
        }
        [self countMoney];
        [self judgeIsOrder];
        [self.collectionView reloadData];
    } Error:nil Failure:^(NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
    }];
}

- (void)orderRorGoods {
    //判断选择的商品属于几个平台的
    NSInteger type = 0;
    for (ShopCarModel *shopModel in self.dataSource) {
        if (shopModel.isSelected) {
            type ++;
            continue;
        }
        for (ShopGoodsModel *goodsModel in shopModel.carGoodsList) {
            if (goodsModel.isSelected) {
                type ++;
                break;
            }
        }
    }
    if (type > 1) {
        [CddHud showTextOnly:@"不能同时提交多家店铺的商品哦" view:self.view];
        return;
    }
    
    NSMutableArray *orderList = [NSMutableArray arrayWithCapacity:0];
    for (ShopCarModel *shopModel in self.dataSource) {
        for (ShopGoodsModel *goodsModel in shopModel.carGoodsList) {
            if (goodsModel.isSelected) {
                NSDictionary *valueDict = @{@"id":goodsModel.goodsId,
                                            @"skuId":goodsModel.skuId,
                                            @"goodsNum":@(goodsModel.goodsNum).stringValue};
                [orderList addObject:valueDict];
            }
        }
    }
    
    ConfirmOrderVC *vc = [[ConfirmOrderVC alloc] init];
    vc.goodsInfoList = [orderList copy];
    vc.money = _totalMoney;
    vc.isCarPay = YES;
    vc.isBargain = NO;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_shopCar"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"购物车空空如也～";
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

#pragma mark - collectionView delegate
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataSource[section] carGoodsList].count;
}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(SCREEN_WIDTH, 50);
}

//设置footer尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

//
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ShopCarSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderCVID forIndexPath:indexPath];
        header.indexPath = indexPath;
        header.model = self.dataSource[indexPath.section];
        DDWeakSelf;
        header.selectStoreBlock = ^(NSIndexPath * _Nonnull atIndexPath) {
            [weakself judgeSelectedAll];
            [weakself countMoney];
            [self judgeIsOrder];
            [weakself.collectionView reloadData];
        };
        view = header;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == 0) {
        
    }
    return view;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [collectionView numberOfItemsInSection:indexPath.section]-1) {
        [HelperTool drawRound:cell.contentView corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:8.f];
    } else {
        [HelperTool drawRound:cell.contentView corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:0.f];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //解决滚动条遮挡问题
    view.layer.zPosition = 0.0;
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCarCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCarCVID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    ShopCarModel *model = self.dataSource[indexPath.section];
    cell.model = model.carGoodsList[indexPath.row];
    [self cellWithHanlder:cell];
    return cell;
}

//各种操作
- (void)cellWithHanlder:(ShopCarCVCell *)cell {
    DDWeakSelf;
    //选择
    cell.selectGoodsBlock = ^(NSIndexPath * _Nonnull atIndexPath) {
        ShopCarModel *sectionModel = weakself.dataSource[atIndexPath.section];
        BOOL isSelectShop = YES;
        for (ShopGoodsModel *md in sectionModel.carGoodsList) {
            if (!md.isSelected) {
                isSelectShop = NO;
            }
        }
        sectionModel.isSelected = isSelectShop;
        [weakself judgeSelectedAll];
        [weakself countMoney];
        [weakself judgeIsOrder];
        [weakself.collectionView reloadData];
    };
    //改变数量,购物车加减时调用
    cell.changeCountBlock = ^(NSIndexPath * _Nonnull atIndexPath, NSInteger count, NSString * _Nonnull carID, NSInteger type) {
        [weakself changeShopCarWithNum:count carID:carID type:type indexPath:atIndexPath];
    };
    //改变数量时超出了范围，比如小于小于0或者大于库存了
    cell.changeCountErrorBlock = ^(NSString * _Nonnull error) {
        [CddHud showTextOnly:error view:weakself.view];
    };
}


#pragma mark - 按钮事件
//判断是否要选中全部选择按钮（只要判断店铺是否全部选择）
- (void)judgeSelectedAll {
    BOOL isAllSelect = YES;
    for (ShopCarModel *model in self.dataSource) {
        //有店铺未选择
        if (!model.isSelected) {
            isAllSelect = NO;
        }
    }
    self.selectAllBtn.selected = isAllSelect;
    [self.collectionView reloadData];
}

//点击选中全部店铺以及店铺下商品
- (void)selectAllGoods {
    _selectAllBtn.selected = !_selectAllBtn.selected;
    for (ShopCarModel *shopModel in self.dataSource) {
        shopModel.isSelected = _selectAllBtn.selected;
        for (ShopGoodsModel *goodsModel in shopModel.carGoodsList) {
            goodsModel.isSelected = _selectAllBtn.selected;
        }
    }
    [self countMoney];
    [self judgeIsOrder];
    [self.collectionView reloadData];
}

//判断购物车是否有商品选中
- (void)judgeIsOrder {
    BOOL flag = false;
    for (NSInteger i = 0; i < self.dataSource.count && !flag; i ++) {
        ShopCarModel *shopModel = self.dataSource[i];
        if (shopModel.isSelected) {
            flag = true;
            break;
        }
        for (NSInteger k = 0; k < shopModel.carGoodsList.count; k ++) {
            ShopGoodsModel *goodsModel = shopModel.carGoodsList[k];
            if (goodsModel.isSelected) {
                flag = true;
                break;
            }
        }
    }
    //结算按钮是否可点击
    _settleAccountBtn.enabled = flag;
    _deleteBtn.enabled = flag;
    if (self.dataSource.count == 0) {
        _selectAllBtn.selected = NO;
    }
}

//计算购物车选中商品总价
- (void)countMoney {
    NSDecimalNumber *totalMoney = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (ShopCarModel *shopModel in self.dataSource) {
        for (ShopGoodsModel *goodsModel in shopModel.carGoodsList) {
            if (goodsModel.isSelected) {
                NSDecimalNumber *count = [NSDecimalNumber decimalNumberWithString:@(goodsModel.goodsNum).stringValue];
                NSDecimalNumber *money = [goodsModel.goodsPrice decimalNumberByMultiplyingBy:count];
                totalMoney = [money decimalNumberByAdding:totalMoney];
            }
        }
    }
    _totalMoney = totalMoney.stringValue;
    _totalPriceLab.text = [NSString stringWithFormat:@"¥ %@",totalMoney];
}

//获取批量删除的购物车id数组
- (NSArray *)getGoodsListWillDelete {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (ShopCarModel *shopModel in self.dataSource) {
        for (ShopGoodsModel *goodsModel in shopModel.carGoodsList) {
            if (goodsModel.isSelected) {
                [arr addObject:goodsModel.shopCarID];
            }
        }
    }
    return [arr copy];
}

- (void)editBtnClick {
    _cancelBtn.hidden = NO;
    _deleteBtn.hidden = NO;
}

- (void)cancelBtnClick {
    _cancelBtn.hidden = YES;
    _deleteBtn.hidden = YES;
}

#pragma mark - setUI
- (void)setupUI {
    UIView *topViw = [[UIView alloc] init];
    topViw.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topViw];
    [topViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(NAV_HEIGHT);
    }];
    
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"icon_unSelect"] forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateSelected];
    [_selectAllBtn setTitleColor:HEXColor(@"#090203", 1) forState:UIControlStateNormal];
    _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_selectAllBtn addTarget:self action:@selector(selectAllGoods) forControlEvents:UIControlEventTouchUpInside];
    [_selectAllBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    _selectAllBtn.adjustsImageWhenHighlighted = NO;
    [topViw addSubview:_selectAllBtn];
    [_selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(topViw);
        make.width.mas_equalTo(52);
    }];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topViw addSubview:_editBtn];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.centerY.mas_equalTo(self.selectAllBtn);
    }];
    [_editBtn.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.backgroundColor = UIColor.whiteColor;
    _cancelBtn.hidden = YES;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topViw addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.editBtn);
    }];
    [_cancelBtn.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //底部结算
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(TABBAR_HEIGHT);
    }];
    
    _settleAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settleAccountBtn setTitle:@"立即结算" forState:UIControlStateNormal];
    [_settleAccountBtn setTintColor:UIColor.whiteColor];
    _settleAccountBtn.adjustsImageWhenHighlighted = NO;
    _settleAccountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _settleAccountBtn.enabled = NO;
    [_settleAccountBtn addTarget:self action:@selector(orderRorGoods) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_settleAccountBtn];
    [_settleAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(100);
    }];
    [_settleAccountBtn.superview layoutIfNeeded];
    NSArray *colors= @[HEXColor(@"#FE7900", 1),HEXColor(@"#FF5100", 1)];
    UIImage *image = [UIImage imageWithGradientColor:colors andRect:_settleAccountBtn.bounds andGradientType:1];
    [_settleAccountBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_settleAccountBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#d6d6d6", 1)] forState:UIControlStateDisabled];
    
    //删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.hidden = YES;
    _deleteBtn.enabled = NO;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTintColor:UIColor.whiteColor];
    [_deleteBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#F01420", 1)] forState:UIControlStateNormal];
    [_deleteBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#d6d6d6", 1)] forState:UIControlStateDisabled];
    [_deleteBtn addTarget:self action:@selector(deleteGoods) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.adjustsImageWhenHighlighted = NO;
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.settleAccountBtn);
    }];
    
    UILabel *totalText = [[UILabel alloc] init];
    totalText.text = @"总计: ";
    totalText.textColor = HEXColor(@"#090203", 1);
    totalText.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:totalText];
    [totalText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.settleAccountBtn);
    }];
    [totalText setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    _totalPriceLab = [[UILabel alloc] init];
    _totalPriceLab.textColor = HEXColor(@"#FF5100", 1);
    _totalPriceLab.text = @"¥ 0";
    _totalPriceLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [bottomView addSubview:_totalPriceLab];
    [_totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalText.mas_right);
        make.centerY.mas_equalTo(totalText);
        make.right.mas_lessThanOrEqualTo(-110);
    }];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(100, 100, 40, 40);
    self.activityIndicator.center = self.view.center;
    //设置小菊花颜色
    self.activityIndicator.color = UIColor.blackColor;
    //设置背景颜色
    self.activityIndicator.backgroundColor = UIColor.clearColor;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
