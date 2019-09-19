//
//  SearchResultVC.h
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultVC : BaseViewController
@property (nonatomic, copy) NSString *keyWords;
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
