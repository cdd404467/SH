//
//  SelectSpecView.m
//  SH
//
//  Created by i7colors on 2019/12/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SelectSpecView.h"
#import "LineLayout.h"
#import "SpecSelectCVCell.h"
#import "GoodsModel.h"
#import "ImageLabView.h"


#define AniTime 0.3
#define View_Height SCREEN_HEIGHT * 0.70
static NSString *cvID = @"SpecSelectCVCell";
static NSString *section_Header = @"SpecSecHeader";
static NSString *section_Footer = @"SpecSecFooter";


@interface SelectSpecView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *inventoryLab;
@property (nonatomic, strong) UIButton *joinShopCarBtn;
@property (nonatomic, strong) UIButton *buyNowBtn;
@property (nonatomic, strong) NSMutableDictionary *specDict;
@property (nonatomic, strong) ImageLabView *countLab;
@end


@implementation SelectSpecView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = SCREEN_BOUNDS;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(complete)];
        backTap.delegate = self;
        [self addGestureRecognizer:backTap];
        self.specDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [self setupUI];
    }
    return self;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LineLayout *layout = [[LineLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //        _collectionView.scrollEnabled = NO; //禁止滚动
        //        _collectionView.showsHorizontalScrollIndicator = NO;
        //        _collectionView.showsVerticalScrollIndicator = NO;//垂直
        _collectionView.backgroundColor = UIColor.whiteColor;
        layout.estimatedItemSize = CGSizeMake(60, Cell_Height);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        //设置内容范围偏移200
//        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        [_collectionView registerClass:[SpecSelectCVCell class] forCellWithReuseIdentifier:cvID];
        [_collectionView registerClass:[SpecSecHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header];
        [_collectionView registerClass:[SpecSecFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:section_Footer];
    }
    return _collectionView;
}

- (void)setupUI {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = UIColor.whiteColor;
    _backgroundView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, View_Height);
    [self addSubview:_backgroundView];
    
    _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, -12, 96, 96)];
    _goodsImage.layer.cornerRadius = 3.f;
    _goodsImage.clipsToBounds = YES;
    _goodsImage.backgroundColor = Like_Color;
    [_backgroundView addSubview:_goodsImage];
    
    UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closebtn.adjustsImageWhenHighlighted = false;
    [closebtn setImage:[UIImage imageNamed:@"page_close"] forState:UIControlStateNormal];
    [closebtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:closebtn];
    [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.width.height.mas_equalTo(30);
    }];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.textColor = HEXColor(@"#FF5100", 1);
    _priceLab.font = [UIFont systemFontOfSize:18];
    [_backgroundView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImage.mas_right).offset(14);
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(closebtn.mas_left).offset(-5);
        make.height.mas_equalTo(25);
    }];
    
    //库存
    _inventoryLab = [[UILabel alloc] init];
    _inventoryLab.textColor = HEXColor(@"#615454", 1);
    _inventoryLab.font = [UIFont systemFontOfSize:12];
    [_backgroundView addSubview:_inventoryLab];
    [_inventoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.priceLab);
        make.bottom.mas_equalTo(self.goodsImage.mas_bottom).offset(-20);
        make.height.mas_equalTo(17);
    }];
    
    CGFloat width = (SCREEN_WIDTH - 3 * 15) / 2;
    _joinShopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_joinShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_joinShopCarBtn setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateNormal];
    _joinShopCarBtn.layer.cornerRadius = 20.f;
    _joinShopCarBtn.backgroundColor = UIColor.whiteColor;
    _joinShopCarBtn.layer.borderColor = HEXColor(@"#FF5100", 1).CGColor;
    _joinShopCarBtn.layer.borderWidth = 1.f;
    [_joinShopCarBtn addTarget:self action:@selector(joinShopCar) forControlEvents:UIControlEventTouchUpInside];
    _joinShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_backgroundView addSubview:_joinShopCarBtn];
    [_joinShopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-Bottom_Height_Dif - 9);
    }];
    
    _buyNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyNowBtn.adjustsImageWhenHighlighted = NO;
    [_buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _buyNowBtn.layer.cornerRadius = 20.f;
    _buyNowBtn.clipsToBounds = YES;
    _buyNowBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_buyNowBtn addTarget:self action:@selector(buyNow) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_buyNowBtn];
    [_buyNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.mas_equalTo(self.joinShopCarBtn);
        make.right.mas_equalTo(-15);
    }];
    [_buyNowBtn.superview layoutIfNeeded];
    NSArray *colors= @[HEXColor(@"#FE7900", 1),HEXColor(@"#FF5100", 1)];
    UIImage *image = [UIImage imageWithGradientColor:colors andRect:_buyNowBtn.bounds andGradientType:1];
    [_buyNowBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    //数量
    UILabel *countTxtLab = [[UILabel alloc] init];
    countTxtLab.text = @"数量";
    countTxtLab.textColor = HEXColor(@"#343333", 1);
    countTxtLab.font = [UIFont systemFontOfSize:14];
    [_backgroundView addSubview:countTxtLab];
    [countTxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.joinShopCarBtn.mas_top).offset(-26);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.adjustsImageWhenHighlighted = false;
    addBtn.tag = 100;
    [addBtn setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(countTxtLab);
    }];
    
    _countLab = [[ImageLabView alloc] init];
    _countLab.textLab.text = @"1";
    _countLab.textLab.textAlignment = NSTextAlignmentCenter;
    _countLab.textLab.font = [UIFont systemFontOfSize:14];
    _countLab.textLab.textColor = HEXColor(@"#343333", 1);
    _countLab.image = [UIImage imageNamed:@"count_display_bg"];
    [_backgroundView addSubview:_countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addBtn.mas_left).offset(-1);
        make.height.centerY.mas_equalTo(addBtn);
        make.width.mas_equalTo(38);
    }];
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.adjustsImageWhenHighlighted = false;
    minusBtn.tag = 101;
    [minusBtn setImage:[UIImage imageNamed:@"minus_icon"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:minusBtn];
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(addBtn);
        make.right.mas_equalTo(self.countLab.mas_left).offset(-1);
        make.centerY.mas_equalTo(self.countLab);
    }];
    
    
    [_backgroundView addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.goodsImage.mas_bottom).offset(12);
        make.bottom.mas_equalTo(-TABBAR_HEIGHT - 65);
    }];
}

//数量加减
- (void)changeCount:(UIButton *)sender {
    SkuListModel *model = self.dataSource.skuList[[self findIndex]];
    int currentNum = self.countLab.textLab.text.intValue;
    //执行加操作
    if (sender.tag == 100) {
        if (currentNum < model.goodsSkuStock ) {
            currentNum = currentNum + 1;
        }
        else {
//            if (self.changeCountErrorBlock) {
//                self.changeCountErrorBlock(@"没有那么多库存了哦");
//            }
        }
    }
    //减操作
    else if (sender.tag == 101) {
        if (currentNum > 1) {
            currentNum = currentNum - 1;
        }
//        else {
//            if (self.changeCountErrorBlock) {
//                self.changeCountErrorBlock(@"不能再少了哦");
//            }
//        }
    }
    self.countLab.textLab.text = @(currentNum).stringValue;
}

- (void)setDataSource:(GoodsDetailModel *)dataSource {
    _dataSource = dataSource;
    if (dataSource.skuList.count == 0) {
        return;
    }
    SkuListModel *model = dataSource.skuList[0];
    [self displayGoodsWithModel:model];
}

- (void)displayGoodsWithModel:(SkuListModel *)model {
    [_goodsImage sd_setImageWithURL:ImgUrl_SD_OSS(model.goodsSkuImg, 90 * 2) placeholderImage:PlaceHolderImg];
    _priceLab.text = [NSString stringWithFormat:@"¥%@",model.goodsSkuRetailPrice];
    _inventoryLab.text = [NSString stringWithFormat:@"库存: %d",model.goodsSkuStock];
    [self.collectionView reloadData];
}

- (void)show {
    self.hidden = NO;
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.backgroundView.top = SCREEN_HEIGHT - View_Height;
    }];
}

- (void)buyNow {
    if (self.buyNowBlock) {
        self.buyNowBlock([self findIndex], self.countLab.textLab.text.intValue);
    }
}

- (void)joinShopCar {
    if (self.joinShopCarBlock) {
        self.joinShopCarBlock([self findIndex],self.countLab.textLab.text.intValue);
    }
}

#pragma mark - collectionView delegate
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.specList.count;
}

/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource.specList[section] goodsSkuSpecVals].count;
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 12;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 10;
}

//四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 15, 10, 15);
}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 30);
}

//设置footer尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 15);
}

//
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (NSInteger i = 0; i < _dataSource.specList.count; i++) {
        //点击的分区
        if (indexPath.section == i) {
            SpecListModel * model = _dataSource.specList[indexPath.section];
            [model.goodsSkuSpecVals enumerateObjectsUsingBlock:^(GoodsSkuSpecValsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //遍历这一个分区
                if (idx == indexPath.item) {
                    obj.isSelected = !obj.isSelected;
                    if (obj.isSelected) {
                        [self.selectArray addObject:obj.goodsSkuSpecValName];
                    } else {
                        [self.selectArray removeObject:obj.goodsSkuSpecValName];
                    }
                }
                else {
                    obj.isSelected = NO;
                    [self.selectArray removeObject:obj.goodsSkuSpecValName];
                }
            }];
        }
        
        SkuListModel *model = self.dataSource.skuList[[self findIndex]];
        [self displayGoodsWithModel:model];
    }
}

//判断元素是否相等
- (BOOL)judgeArray:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
}

//找到选择的sku的index
- (NSInteger)findIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataSource.skuList.count; i++ ) {
        SkuListModel *model  = self.dataSource.skuList[i];
        //如果相同
        if ([self judgeArray:[self.selectArray copy] isEqualTo:model.skuNameArr]) {
            index = i;
            break;
        }
    }
    return index;
}

//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SpecListModel *spModel = _dataSource.specList[indexPath.section];
        SpecSecHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header forIndexPath:indexPath];
        header.title = spModel.goodsSpecName;
        view = header;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        SpecSecFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:section_Footer forIndexPath:indexPath];
        view = footer;
    }
    return view;
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //重用cell
    SpecSelectCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvID forIndexPath:indexPath];
    SpecListModel *spModel = _dataSource.specList[indexPath.section];
    cell.model = spModel.goodsSkuSpecVals[indexPath.row];
    return cell;
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
//    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
//        return NO;
//    }
    if (touch.view.height < SCREEN_HEIGHT - 20) {
        return NO;
    }
    return YES;
}

- (void)complete {
    SkuListModel *model = self.dataSource.skuList[[self findIndex]];
    [self.specDict setValue:model.goodsSkuName forKey:@"specTxt"];
    [self.specDict setValue:model.goodsSkuImg forKey:@"specImg"];
    if (self.completeBlock) {
        self.completeBlock(self.specDict);
    }
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundView.top = SCREEN_HEIGHT;
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


- (void)removeAllSubviews {
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundView.top = SCREEN_HEIGHT;
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

@end

@implementation SpecSecHeader {
    UILabel *_titleName;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //标题
    _titleName = [[UILabel alloc] init];
    _titleName.font = [UIFont systemFontOfSize:14];
    _titleName.textColor = HEXColor(@"#343333", 1);
    [self addSubview:_titleName];
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-2);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
    
}
    
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleName.text = title;
}

@end

@implementation SpecSecFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"#f1f1f1", 0.8);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

@end

