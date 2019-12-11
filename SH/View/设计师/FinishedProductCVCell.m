//
//  FinishedProductCVCell.m
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "FinishedProductCVCell.h"
#import "DesignerModel.h"

@interface FinishedProductCVCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation FinishedProductCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = HEXColor(@"#F6F6F6", 1);
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setModel:(FinishedWorkModel *)model {
    _model = model;
    int width = (SCREEN_WIDTH - 15 * 2 - 10);
    [_imageView sd_setImageWithURL:ImgUrl_SD_OSS(model.works, width) placeholderImage:PlaceHolderImg];
}


@end
