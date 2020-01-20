//
//  VCJump.h
//  SH
//
//  Created by i7colors on 2020/1/9.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCJump : NSObject
//分享打开
+ (void)openShareURLWithHost:(NSString *)host query:(NSString *)query nav:(BaseNavigationController *)nav;
@end

NS_ASSUME_NONNULL_END
