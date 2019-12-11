//
//  SpecSelectCVCell.m
//  SH
//
//  Created by i7colors on 2019/12/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SpecSelectCVCell.h"
#import "GoodsModel.h"

@implementation SpecSelectCVCell {
    UILabel *_labsLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _labsLab = [[UILabel alloc] init];
    _labsLab.frame = CGRectMake(0, 0, 30, 32);
    _labsLab.textAlignment = NSTextAlignmentCenter;
    _labsLab.font = [UIFont systemFontOfSize:12];
//    _labsLab.backgroundColor = HEXColor(@"#F6F6F6", 1);
//    _labsLab.textColor = HEXColor(@"#343333", .8);
    _labsLab.layer.borderWidth = 1.f;
    _labsLab.clipsToBounds = YES;
    _labsLab.layer.borderColor = UIColor.clearColor.CGColor;
    _labsLab.layer.cornerRadius = 4.f;
    [self.contentView addSubview:_labsLab];
    
}

- (void)setModel:(GoodsSkuSpecValsModel *)model {
    _model = model;
    _labsLab.backgroundColor = model.isSelected ? HEXColor(@"#FDF4F2", 1) : HEXColor(@"#F6F6F6", 1);
    _labsLab.textColor = model.isSelected ? HEXColor(@"#FF5100", 1) : HEXColor(@"#343333", 1);
    _labsLab.layer.borderColor = model.isSelected ? HEXColor(@"#FF5100", 1).CGColor : UIColor.clearColor.CGColor;
    _labsLab.text = model.goodsSkuSpecValName;
    CGFloat width = [_labsLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 32)
       options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{NSFontAttributeName:_labsLab.font}
       context:nil].size.width;
    _labsLab.width = width + 30;
    model.cellWidth = _labsLab.width;
}

// 返回特定的高
-(UICollectionViewLayoutAttributes *) preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    UICollectionViewLayoutAttributes *attributes = [layoutAttributes copy];
    
    attributes.size = CGSizeMake(_model.cellWidth, Cell_Height);
    return attributes;
}
@end
