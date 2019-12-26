//
//  CddActionSheetView.h
//  QCY
//
//  Created by i7colors on 2019/4/30.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CddActionSheetView : UIView
//选项高度 默认为6
@property (nonatomic, assign) CGFloat gapHeight;
//标题
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithOptions:(NSArray<NSArray *> *)titles completion:(void (^)(NSInteger index))completion cancel:(nullable void (^)(void))cancelBlock;

//底部alert
- (instancetype)initWithSheetOKTitle:(NSString *)ok cancelTitle:(NSString *)cancel completion:(void (^)(void))completion cancel:(nullable void (^)(void))cancelBlock;

- (void)show;
@end

NS_ASSUME_NONNULL_END
