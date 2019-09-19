//
//  WebViewVC.h
//  SH
//
//  Created by i7colors on 2019/9/4.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewVC : BaseViewController
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, assign) BOOL needBottom;
@property (nonatomic, copy) NSString *webTitle;
@end

NS_ASSUME_NONNULL_END
