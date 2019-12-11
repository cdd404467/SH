//
//  SelectLabView.m
//  SH
//
//  Created by i7colors on 2019/12/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SelectLabView.h"
#import "LabelModel.h"

#define AniTime 0.3
#define SignLabWidth (SCREEN_WIDTH - 25 * 2 - 20 * 2) / 3
#define ViewHeight SCREEN_HEIGHT * 0.55

@interface SelectLabView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UIView *backgroundView;

@end

@implementation SelectLabView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = SCREEN_BOUNDS;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(complete)];
        backTap.delegate = self;
        [self addGestureRecognizer:backTap];
    }
    return self;
}

- (void)show {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    DDWeakSelf;
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = UIColor.whiteColor;
    _backgroundView.frame = CGRectMake(0, -ViewHeight, SCREEN_WIDTH, ViewHeight);
    [self addSubview:_backgroundView];
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"标签";
    txtLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    txtLab.textColor = HEXColor(@"#090203", 1);
    [_backgroundView addSubview:txtLab];
    [txtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backgroundView);
        make.top.mas_equalTo(STATEBAR_HEIGHT + 12);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = HEXColor(@"#D6D6D6", 1);
    [_backgroundView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(txtLab.mas_left).offset(-10);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(txtLab);
        make.width.mas_equalTo(30);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = HEXColor(@"#D6D6D6", 1);
    [_backgroundView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(txtLab.mas_right).offset(10);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(txtLab);
        make.width.mas_equalTo(30);
    }];
    
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [_backgroundView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(txtLab.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-75);
    }];
    
    CGFloat width = (SCREEN_WIDTH - 25 * 2 - 15) / 2;
    
    UIButton *resetlbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetlbtn.layer.cornerRadius = 20.f;
    [resetlbtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetlbtn addTarget:self action:@selector(resetSelect) forControlEvents:UIControlEventTouchUpInside];
    resetlbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [resetlbtn setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateNormal];
    resetlbtn.layer.borderColor = HEXColor(@"#FF5100", 1).CGColor;
    resetlbtn.layer.borderWidth = 1.f;
    [_backgroundView addSubview:resetlbtn];
    [resetlbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-18);
    }];
    
    
    UIButton *yesbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesbtn setTitle:@"确定" forState:UIControlStateNormal];
    yesbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [yesbtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [yesbtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    yesbtn.layer.cornerRadius = 20.f;
    yesbtn.clipsToBounds = YES;
    [_backgroundView addSubview:yesbtn];
    [yesbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.width.height.bottom.mas_equalTo(resetlbtn);
    }];
    [yesbtn.superview layoutIfNeeded];
    NSArray *colors= @[HEXColor(@"#FE7900", 1),HEXColor(@"#FF5100", 1)];
    UIImage *image = [UIImage imageWithGradientColor:colors andRect:yesbtn.bounds andGradientType:1];
    [yesbtn setBackgroundImage:image forState:UIControlStateNormal];
    
    [UIView animateWithDuration:AniTime animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.5);
        weakself.backgroundView.top = 0;
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
//    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
//        return NO;
//    }
    
    if (touch.view.height < SCREEN_HEIGHT - NAV_HEIGHT) {
        return NO;
    }
    
    return YES;
}

- (void)removeAllSubviews {
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundView.top = -ViewHeight;
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)complete {
    NSMutableArray *stArr = [NSMutableArray arrayWithCapacity:0];
    for (LabelSelectModel *model in self.dataSource) {
        if (model.isSelected) {
            [stArr addObject:model.labelId];
        }
    }
    NSString *labsID = [stArr componentsJoinedByString:@","];
    if (self.completeBlock) {
        self.completeBlock(labsID);
    }
    [self removeAllSubviews];
}

- (void)resetSelect {
    for (LabelSelectModel *model in self.dataSource) {
        if (model.isSelected) {
            model.isSelected = NO;
        }
    }
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        //        _collectionView.scrollEnabled = NO; //禁止滚动
        //        _collectionView.showsHorizontalScrollIndicator = NO;
        //        _collectionView.showsVerticalScrollIndicator = NO;//垂直
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        //设置内容范围偏移200
//        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        [_collectionView registerClass:[CustomLabsCell class] forCellWithReuseIdentifier:@"CustomLabsCell"];
        
    }
    
    return _collectionView;
}

#pragma mark - collectionView代理
//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //重用cell
    CustomLabsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomLabsCell" forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LabelSelectModel *model = self.dataSource[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SignLabWidth , 32);
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 15;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}

//四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15, 25, 10, 25);
}

@end


//自定义cell
@implementation CustomLabsCell {
    UILabel *_labsLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _labsLab = [[UILabel alloc] init];
    _labsLab.frame = CGRectMake(0, 0, SignLabWidth, 32);
    _labsLab.textAlignment = NSTextAlignmentCenter;
    _labsLab.font = [UIFont systemFontOfSize:14];
    _labsLab.backgroundColor = HEXColor(@"#F6F6F6", 1);
    _labsLab.textColor = HEXColor(@"#4A4A4A", .8);
    _labsLab.layer.borderWidth = 1.f;
    _labsLab.clipsToBounds = YES;
    _labsLab.layer.borderColor = UIColor.clearColor.CGColor;
    _labsLab.layer.cornerRadius = 4.f;
    [self.contentView addSubview:_labsLab];
}

- (void)setModel:(LabelSelectModel *)model {
    _model = model;
    _labsLab.text = model.name;
    _labsLab.backgroundColor = model.isSelected ? HEXColor(@"#FF5100", 0.2) : HEXColor(@"#F6F6F6", 1);
    _labsLab.textColor = model.isSelected ? HEXColor(@"#FF5100", 1) : HEXColor(@"#4A4A4A", 1);
    _labsLab.layer.borderColor = model.isSelected ? HEXColor(@"#FF5100", 1).CGColor : UIColor.clearColor.CGColor;
}



//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//
//    _labsLab.backgroundColor = selected ? HEXColor(@"#FF5100", 0.2) : HEXColor(@"#F6F6F6", 1);
//    _labsLab.textColor = selected ? HEXColor(@"#FF5100", 1) : HEXColor(@"#4A4A4A", 1);
//    _labsLab.layer.borderColor = selected ? HEXColor(@"#FF5100", 1).CGColor : UIColor.clearColor.CGColor;
//}




@end
