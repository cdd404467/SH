//
//  BannerImageCell.m
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BannerImageCell.h"
#import <UIImageView+WebCache.h>

@interface BannerImageCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BannerImageCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_imageView sd_setImageWithURL:_imageURL placeholderImage:TestImage];
}

@end
