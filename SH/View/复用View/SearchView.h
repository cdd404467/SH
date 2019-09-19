//
//  SearchView.h
//  SH
//
//  Created by i7colors on 2019/9/17.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CancelBlock)(void);
typedef void(^SearchBlock)(void);
@interface SearchView : UIView
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) SearchBlock searchBlock;
@end

NS_ASSUME_NONNULL_END
