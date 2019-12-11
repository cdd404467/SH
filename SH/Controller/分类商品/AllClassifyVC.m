//
//  AllClassifyVC.m
//  SH
//
//  Created by i7colors on 2019/9/11.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "AllClassifyVC.h"
#import "NetTool.h"
#import "ClassifyModel.h"
#import "FirstClassifyTBCell.h"
#import "SecondClassifyCVCell.h"
#import "GoodsListVC.h"

static NSString *cvID = @"SecondClassifyCVCell";

@interface AllClassifyVC ()<UITableViewDelegate, UITableViewDataSource,
                            UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *headerNameLab;
@end

@implementation AllClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.titleLabel.text = @"全部分类";
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightCollectionView];
    [self setupUI];
    [self requestData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, KFit_W(100), SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _leftTableView.rowHeight = 50;
        //取消垂直滚动条
        _leftTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _leftTableView.estimatedRowHeight = 0;
            _leftTableView.estimatedSectionHeaderHeight = 0;
            _leftTableView.estimatedSectionFooterHeight = 0;
            _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif + 20, 0);
    }
    return _leftTableView;
}

//collectionView
- (UICollectionView *)rightCollectionView {
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat lineSpace = 25;
        CGFloat itemSpace = KFit_W(26);
        CGFloat edgeSpace = 22;
        CGFloat itemWidth = (SCREEN_WIDTH - KFit_W(100) - edgeSpace * 2 - itemSpace * 2) / 3;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth + 30);
        layout.minimumInteritemSpacing = itemSpace;
        layout.minimumLineSpacing = lineSpace;
        layout.sectionInset = UIEdgeInsetsMake(5, edgeSpace, edgeSpace, edgeSpace);
        CGRect rect = CGRectMake(KFit_W(100), NAV_HEIGHT, SCREEN_WIDTH - KFit_W(100), SCREEN_HEIGHT - NAV_HEIGHT);
        _rightCollectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _rightCollectionView.backgroundColor = UIColor.whiteColor;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _rightCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _rightCollectionView.contentInset = UIEdgeInsetsMake(50, 0, Bottom_Height_Dif + 20, 0);
        [_rightCollectionView registerClass:[SecondClassifyCVCell class] forCellWithReuseIdentifier:cvID];
        
    }
    return _rightCollectionView;
}

- (void)setupUI {
    self.headerNameLab = [[UILabel alloc] init];
    self.headerNameLab.backgroundColor = UIColor.whiteColor;
    self.headerNameLab.frame = CGRectMake(self.leftTableView.width, NAV_HEIGHT, self.rightCollectionView.width, 50);
    self.headerNameLab.textAlignment = NSTextAlignmentCenter;
    self.headerNameLab.textColor = HEXColor(@"#2B2311", 1);
    self.headerNameLab.backgroundColor = UIColor.whiteColor;
    self.headerNameLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.headerNameLab];
}

#pragma mark 请求数据
- (void)requestData {
    [NetTool getRequest:URLGet_All_Classify Params:nil Success:^(id  _Nonnull json) {
//           NSLog(@"----   %@",json);
        self.dataSource = [ClassifyModel mj_objectArrayWithKeyValuesArray:json];
        for (ClassifyModel *model in self.dataSource) {
            model.secondClassify = [ClassifyModel mj_objectArrayWithKeyValuesArray:model.secondClassify];
        }
        [self.leftTableView reloadData];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        self.headerNameLab.text = [self.dataSource[0] name];
        [self.rightCollectionView reloadData];
    } Failure:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    self.headerNameLab.text = [self.dataSource[indexPath.row] name];
    [self.rightCollectionView reloadData];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstClassifyTBCell *cell = [FirstClassifyTBCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource.count > 0) {
        NSInteger selectedRow = self.leftTableView.indexPathForSelectedRow.row;
        return [[self.dataSource[selectedRow] secondClassify] count];
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsListVC *vc = [[GoodsListVC alloc] init];
    NSInteger selectedRow = self.leftTableView.indexPathForSelectedRow.row;
    ClassifyModel *model = [self.dataSource[selectedRow] secondClassify][indexPath.row];
    vc.classifyId = model.classifyID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SecondClassifyCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvID forIndexPath:indexPath];
    NSInteger selectedRow = self.leftTableView.indexPathForSelectedRow.row;
    cell.model = [self.dataSource[selectedRow] secondClassify][indexPath.row];
    return cell;
}
@end
