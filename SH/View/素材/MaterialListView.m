//
//  MaterialListView.m
//  SH
//
//  Created by i7colors on 2019/11/27.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MaterialListView.h"
#import "SpecialImageView.h"

@interface MaterialListView()
// 图片数组
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@end

@implementation MaterialListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.gap = 8.f;
        self.line = 2;
        self.rows = 3;
        //小图
        CGFloat width = (frame.size.width - (self.rows - 1) * self.gap) / self.rows;
        _imageViewsArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < 6; i++) {
            SpecialImageView *imageView = [[SpecialImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            [_imageViewsArray addObject:imageView];
            [self addSubview:imageView];
        }
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    //最多16张
    NSInteger count = self.line * self.rows;
    if (dataSource.count > self.line * self.rows) {
        dataSource = [dataSource subarrayWithRange:NSMakeRange(0, count)];
    }
    _dataSource = dataSource;
    
    self.hidden = dataSource.count == 0 ? YES : NO;
    for (SpecialImageView *imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    SpecialImageView *imageView = nil;
    for (NSInteger i = 0; i < dataSource.count; i ++) {
        imageView = _imageViewsArray[i];
        imageView.hidden = NO;
        //所在行的第几个
        NSInteger colNum = i % 3;
        //所在哪一行
        NSInteger rowNum = i / 3;
        CGFloat imageX = colNum * (imageView.width + self.gap);
        CGFloat imageY = rowNum * (imageView.height + self.gap);
        imageView.left = imageX;
        imageView.top = imageY;
        [imageView.imageView sd_setImageWithURL:[NSURL URLWithString:dataSource[i]] placeholderImage:PlaceHolderImg];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
    }
    
    self.height = imageView.bottom;
}

- (void)tap:(UIGestureRecognizer *)gesture
{
//    SpecialImageView *imageView = (SpecialImageView *)gesture.view;
//    if (self.clickBlock) {
//        self.clickBlock([self.dataSource[imageView.tag] materialId]);
//    }
}

@end
