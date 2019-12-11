//
//  DynamicStateImgView.m
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DynamicStateImgView.h"
#import <YBImageBrowser.h>
#import <YBIBVideoData.h>
#import "SpecialImageView.h"
#import "DesignerModel.h"

@interface DynamicStateImgView()
// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageViewsArray;

@end

@implementation DynamicStateImgView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    // 小图(九宫格)
    _imageViewsArray = [[NSMutableArray alloc] init];
    CGFloat gap = 6.f;
    CGFloat width = (SCREEN_WIDTH - 60 - 3 * gap) / 4;
    for (NSInteger i = 0; i < 16; i++) {
        SpecialImageView *spImageView = [[SpecialImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        spImageView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        spImageView.margins = 8;
        [_imageViewsArray addObject:spImageView];
        [self addSubview:spImageView];
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    //最多16张
    if (dataSource.count > 16) {
        dataSource = [dataSource subarrayWithRange:NSMakeRange(0, 16)];
    }
    _dataSource = dataSource;
    self.hidden = dataSource.count == 0 ? YES : NO;
    for (SpecialImageView *imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    
    NSInteger count = dataSource.count;
    SpecialImageView *spImageView = nil;
    CGFloat gap = 6.f;
    CGFloat width = (SCREEN_WIDTH - 60 - 3 * gap) / 4;
    
    for (NSInteger i = 0; i < count; i ++) {
        if (i > 15) break;
        DynamicImgModel *model = dataSource[i];
        //所在行的第几个
        NSInteger colNum = i % 4;
        //所在哪一行
        NSInteger rowNum = i / 4;
        CGFloat imageX = colNum * (width + gap);
        CGFloat imageY = rowNum * (width + gap);
//        CGRect frame = CGRectMake(imageX, imageY, width, width);
        spImageView = _imageViewsArray[i];
        spImageView.hidden = NO;
//        imageView.frame = frame;
        spImageView.left = imageX;
        spImageView.top = imageY;
        //九宫格展示
        [spImageView.imageView sd_setImageWithURL:ImgUrl_SD_OSS(model.logo, (int)width * 2) placeholderImage:PlaceHolderImg];
                
        spImageView.userInteractionEnabled = YES;
        spImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        spImageView.tag = i;
        
        [HelperTool drawRound:spImageView radiu:6.f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [spImageView addGestureRecognizer:tap];
        
    }
    self.width = SCREEN_WIDTH - 60;
    self.height = spImageView.bottom;
}

- (void)tap:(UIGestureRecognizer *)gesture {
    SpecialImageView *imageView = (SpecialImageView *)gesture.view;
    if (self.clickBlock) {
        self.clickBlock([self.dataSource[imageView.tag] materialId]); 
    }
}

@end

