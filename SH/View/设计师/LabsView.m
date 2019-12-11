//
//  LabsView.m
//  SH
//
//  Created by i7colors on 2019/11/28.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "LabsView.h"
#import "ImageLabView.h"

@interface LabsView()
// 图片数组
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@end

@implementation LabsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViewsArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < 3; i++) {
            ImageLabView *view = [[ImageLabView alloc] init];
            view.frame = CGRectMake(i * (60 + 4), 0, 60, 17);
            view.hidden = YES;
            [_imageViewsArray addObject:view];
            [self addSubview:view];
        }
    }
    return self;
}

- (void)setLabelArray:(NSArray *)labelArray {
    if (labelArray.count > 3) {
        labelArray = [labelArray subarrayWithRange:NSMakeRange(0, 3)];
    }
    ImageLabView *view = nil;
    for (NSInteger i = 0; i < labelArray.count; i ++) {
        view = _imageViewsArray[i];
        view.hidden = NO;
        view.textLab.text = labelArray[i];
    }
}

@end
