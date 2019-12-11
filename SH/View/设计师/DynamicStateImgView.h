//
//  DynamicStateImgView.h
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(NSString *materialId);
@interface DynamicStateImgView : UIView
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
