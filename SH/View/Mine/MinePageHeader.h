//
//  MinePageHeader.h
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnClickBlock)(NSInteger type);
@interface MinePageHeader : UIView
//头像
@property (nonatomic, strong) UIImageView *headerImageView;
//昵称
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, copy) BtnClickBlock btnClickBlock;
@end

NS_ASSUME_NONNULL_END
