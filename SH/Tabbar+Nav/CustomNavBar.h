//
//  CustomNavBar.h
//  SH
//
//  Created by i7colors on 2019/10/30.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomNavBar : UIImageView
@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
