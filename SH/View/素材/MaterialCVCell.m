//
//  MaterialCVCell.m
//  SH
//
//  Created by i7colors on 2019/9/22.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MaterialCVCell.h"
#import "MaterialModel.h"
#import "LabsView.h"


@interface MaterialCVCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIImageView *isCollectImg;
@property (nonatomic, strong) LabsView *labsView;
@end

@implementation MaterialCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(110);
    }];
    
    _isCollectImg = [[UIImageView alloc] init];
    _isCollectImg.frame = CGRectMake(12, 0, 13, 15);
    [self.imageView addSubview:_isCollectImg];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = HEXColor(@"#090203", 1);
    _nameLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(15);
        make.top.mas_equalTo(self.imageView);
        make.right.mas_lessThanOrEqualTo(-100);
    }];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.textColor = HEXColor(@"#FF5100", 1);
    _priceLab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    _priceLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_right).offset(3);
        make.centerY.mas_equalTo(self.nameLab);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-10);
    }];
    
    _labsView = [[LabsView alloc] init];
    [self.contentView addSubview:_labsView];
    [_labsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.right.mas_equalTo(self.priceLab);
        make.height.mas_equalTo(17);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(21);
    }];
    
    //描述介绍
    _detailLab = [[UILabel alloc] init];
    _detailLab.numberOfLines = 2;
    _detailLab.textColor = HEXColor(@"#9B9B9B", 1);
    _detailLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [self.contentView addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.bottom.mas_equalTo(self.imageView.mas_bottom).offset(-2);
        make.right.mas_equalTo(-10);
    }];
}

- (void)setModel:(MaterialModel *)model {
    _model = model;
    [_imageView sd_setImageWithURL:ImgUrl_SD_OSS(model.logo, 130) placeholderImage:PlaceHolderImg];
    _nameLab.text = model.name;
    _priceLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    _detailLab.text = model.detail;
    _isCollectImg.image = model.isCollect ? [UIImage imageNamed:@"has_collect_icon"] : [UIImage imageNamed:@"not_collect_icon"];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    for (LabelModel *m in model.labelInfoList) {
        [mArr addObject:m.name];
    }
    _labsView.labelArray = [mArr copy];
}

// 返回特定的高
-(UICollectionViewLayoutAttributes *) preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    return layoutAttributes;
}
@end
