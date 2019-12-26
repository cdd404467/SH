//
//  DesignerCVCell.m
//  SH
//
//  Created by i7colors on 2019/9/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DesignerCVCell.h"
#import "DesignerModel.h"
#import "ImageLabView.h"
#import "LabsView.h"
#import "MaterialListView.h"

@interface DesignerCVCell()
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel  *levelLab;
@property (nonatomic, strong) NSMutableArray *signLabArray;
@property (nonatomic, strong) UILabel  *introduceLab;
@property (nonatomic, strong) LabsView *labsView;
@property (nonatomic, strong) MaterialListView *imgListView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation DesignerCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (NSMutableArray *)signLabArray {
    if (!_signLabArray) {
        _signLabArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _signLabArray;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 215);
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 6.f;
    [self.contentView addSubview:bgView];
    _bgView = bgView;
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    
    _headerImage = [[UIImageView alloc] init];
    [bgView addSubview:_headerImage];
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.width.height.mas_equalTo(44);
    }];
    [_headerImage.superview layoutIfNeeded];
    [HelperTool drawRound:_headerImage];
    
    //详情按钮
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn setTitleColor:HEXColor(@"#9B9B9B", 1) forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.headerImage);
        make.height.mas_equalTo(20);
    }];
    [detailBtn.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    detailBtn.hidden = YES;
    
    _nickNameLab = [[UILabel alloc] init];
    _nickNameLab.textColor = HEXColor(@"#090203", 1);
    _nickNameLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [bgView addSubview:_nickNameLab];
    [_nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImage.mas_right).offset(20);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(detailBtn);
        make.right.mas_lessThanOrEqualTo(detailBtn.mas_left).offset(-45);
    }];
    
    _levelLab = [[UILabel alloc] init];
    _levelLab.backgroundColor = HEXColor(@"#FF5100", 1);
    _levelLab.textAlignment = NSTextAlignmentCenter;
    _levelLab.textColor = UIColor.whiteColor;
    _levelLab.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];;
    [bgView addSubview:_levelLab];
    [_levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nickNameLab.mas_right).offset(5);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(34);
        make.centerY.mas_equalTo(self.nickNameLab);
    }];
    [_levelLab.superview layoutIfNeeded];
    [HelperTool drawRound:_levelLab radiu:8.f];
    
    [_nickNameLab.superview layoutIfNeeded];
    _labsView = [[LabsView alloc] initWithFrame:CGRectMake(_nickNameLab.left, _nickNameLab.bottom + 8, bgView.width - _nickNameLab.left - 15, 18)];
    [bgView addSubview:_labsView];
    
    _introduceLab = [[UILabel alloc] init];
    _introduceLab.frame = CGRectMake(_nickNameLab.left, _labsView.bottom + 12, _labsView.width, 0);
    _introduceLab.textColor = HEXColor(@"#4A4A4A", 1);
    _introduceLab.font = [UIFont systemFontOfSize:13];
    _introduceLab.numberOfLines = 2;
    [bgView addSubview:_introduceLab];
    
    _imgListView = [[MaterialListView alloc] initWithFrame:CGRectMake(_introduceLab.left, 0, _introduceLab.width, 0)];
    [bgView addSubview:_imgListView];
}

- (void)btnClick {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setModel:(DesignerModel *)model {
    _model = model;
    [_headerImage sd_setImageWithURL:ImgUrl_SD_OSS(model.headimgurl,88) placeholderImage:PlaceHolderImg];
    _nickNameLab.text = model.designerName;
    _levelLab.text = [NSString stringWithFormat:@"lv%ld",(long)model.level];
    _labsView.labelArray = model.labelArray;
    _introduceLab.text = model.detail;
    
    CGFloat maxHeight = _introduceLab.font.lineHeight * 2;
    CGFloat height = [_introduceLab.text boundingRectWithSize:CGSizeMake(_introduceLab.width, CGFLOAT_MAX)
       options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{NSFontAttributeName : _introduceLab.font}
                         context:nil].size.height;
    
    if (height > maxHeight) {
        _introduceLab.height = maxHeight;
    } else {
        _introduceLab.height = height;
    }
    if (isRightData(model.detail)) {
        _introduceLab.hidden = NO;
    } else {
        _introduceLab.hidden = YES;
    }
    _imgListView.dataSource = model.materialList;
    _imgListView.top = _introduceLab.bottom + 17;
    _bgView.height = _imgListView.bottom + 10;
    model.cellHeight = _imgListView.bottom + 10;
}

// 返回特定的高
-(UICollectionViewLayoutAttributes *) preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    attributes.size = CGSizeMake(SCREEN_WIDTH - 20, _model.cellHeight);
    return attributes;
}

@end
