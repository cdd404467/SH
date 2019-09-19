//
//  SearchResultVC.m
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SearchResultVC.h"
#import "SearchView.h"
#import "NetTool.h"
#import "HomeSceneCVCell.h"
#import "HomePageModel.h"

static NSString *sceneCVID = @"sceneCell";

@interface SearchResultVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"场景列表";
    [self setupUI];
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (void)setupUI {
    SearchView *searchView = [[SearchView alloc] init];
    searchView.top = NAV_HEIGHT;
    searchView.searchTF.placeholder = self.title;
    searchView.searchTF.text = _keyWords;
    DDWeakSelf;
    searchView.searchBlock = ^{
        [weakself requestData];
    };
    [self.view addSubview:searchView];
    _searchView = searchView;
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
        CGRect rect = CGRectMake(0, self.searchView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.bottom);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        [_collectionView registerClass:[HomeSceneCVCell class] forCellWithReuseIdentifier:sceneCVID];
        
    }
    
    return _collectionView;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Index_SearchAppoint,(int)_type,_searchView.searchTF.text,1,@"",PageCount,self.pageNumber];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
                NSLog(@"----   %@",json);
        NSArray *tempArr = [SceneModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        [self.dataSource addObjectsFromArray:tempArr];
        [self.collectionView reloadData];
        
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH , KFit_W(200) + 50);
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeSceneCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneCVID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

@end
