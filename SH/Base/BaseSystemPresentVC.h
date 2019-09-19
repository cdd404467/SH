//
//  BaseSystemPresentVC.h
//  QCY
//
//  Created by i7colors on 2019/4/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseSystemPresentVC : BaseViewController
@property (nonatomic, strong)UIButton *rightNavBtn;
- (void)useImgMode;
- (void)hideRightBtn;
- (void)displayRightbtn;
@end

NS_ASSUME_NONNULL_END
