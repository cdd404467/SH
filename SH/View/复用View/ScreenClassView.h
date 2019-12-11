//
//  ScreenClassView.h
//  SH
//
//  Created by i7colors on 2019/11/22.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnClickBlock)(NSInteger type);
@interface ScreenClassView : UICollectionReusableView
@property (nonatomic, copy) BtnClickBlock btnClickBlock;
@end

NS_ASSUME_NONNULL_END
