//
//  GoodsListVC.m
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "GoodsListVC.h"
#import "HotGoodsCVCell.h"
#import "NetTool.h"
#import "UIView+Border.h"
#import "GoodsModel.h"
#import "GoodsDetailsVC.h"


static NSString *cvID = @"HotGoodsCVCell";

@interface GoodsListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//综合
@property (nonatomic, strong) UIButton *synthesizeBtn;
//销量
@property (nonatomic, strong) UIButton *saleBtn;
//价格
@property (nonatomic, strong) UIButton *priceBtn;
//选中按钮
@property (nonatomic, strong)UIButton *selectedBtn;
//选中按钮tag - 10000
@property (nonatomic, assign)NSInteger selectedTag;
@end

@implementation GoodsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";
    [self setupUI];
    [self requestData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
        layout.itemSize = CGSizeMake(imageWidth , imageWidth + 96);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
        CGRect rect = SCREEN_BOUNDS;
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT + 49, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
        [_collectionView registerClass:[HotGoodsCVCell class] forCellWithReuseIdentifier:cvID];
    }
    return _collectionView;
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 49);
    topView.backgroundColor = UIColor.whiteColor;
    [topView addBorder:HEXColor(@"#F6F6F6", 1) width:0.7f direction:BorderDirectionBottom];
    [self.view addSubview:topView];
    
    NSArray *titleArr = @[@"综合",@"销量",@"价格"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXColor(@"#9B9B9B", 1) forState:UIControlStateNormal];
        [button setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [button addTarget:self action:@selector(selectClassify:) forControlEvents:UIControlEventAllTouchEvents];
        button.tag = i + 10001;
        [topView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.mas_equalTo(55);
            } else if (i == 1) {
                make.centerX.mas_equalTo(topView);
            } else {
                make.right.mas_equalTo(-55);
            }
            make.centerY.mas_equalTo(topView);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(40);
        }];
        
        if (i == 0) {
            self.synthesizeBtn = button;
            self.synthesizeBtn.selected = YES;
            self.selectedBtn = self.synthesizeBtn;
            self.selectedTag = self.selectedBtn.tag - 10000;
        } else if (i == 1) {
            self.saleBtn = button;
        } else {
            self.priceBtn = button;
        }
    }
}

- (void)selectClassify:(UIButton *)sender {
    sender.highlighted = NO;
//    self.pageNumber = 1;
    if (sender != self.selectedBtn ) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        self.selectedTag = self.selectedBtn.tag - 10000;
        [self requestData];
    }
}

#pragma mark 请求数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Goods_ClassifyList,_classifyId,(int)_selectedTag,PageCount,self.pageNumber];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//                NSLog(@"----   %@",json);
        if (self.pageNumber == 1)
            [self.dataSource removeAllObjects];
        NSArray *tempArr = [GoodsModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        [self.dataSource addObjectsFromArray:tempArr];
        [self.collectionView reloadData];
        
    } Failure:^(NSError * _Nonnull error) {
//        NSLog(@"----   %@",error);
    }];
}


#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsDetailsVC *vc= [[GoodsDetailsVC alloc] init];
    GoodsModel *model = self.dataSource[indexPath.row];
    vc.goodsID = model.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
