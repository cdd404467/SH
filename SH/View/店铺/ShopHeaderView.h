//
//  ShopHeaderView.h
//  SH
//
//  Created by i7colors on 2020/1/14.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopHeaderView : UIView
@property (nonatomic, strong) UIImageView *shopLogo;
@property (nonatomic, strong) UILabel *shopNameLab;
@property (nonatomic, copy) NSArray *bannerArray;
@end

NS_ASSUME_NONNULL_END
