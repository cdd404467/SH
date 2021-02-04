//
//  StarView.h
//  SH
//
//  Created by i7colors on 2020/2/23.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarView;


NS_ASSUME_NONNULL_BEGIN

@protocol CWStarRateViewDelegate <NSObject>
@optional
- (void)starRateView:(StarView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent;
@end

@interface StarView : UIView
@property (nonatomic, assign) CGFloat scorePercent;//得分值，范围为0--1，默认为1
@property (nonatomic, assign) BOOL hasAnimation;//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL allowIncompleteStar;//评分时是否允许不是整星，默认为NO

@property (nonatomic, weak) id<CWStarRateViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;
@end

NS_ASSUME_NONNULL_END
