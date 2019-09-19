//
//  LoaderPlaceholder.h
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoaderPlaceholder : NSObject
+(void)addLoaderToTargetView:(UIView *)listView;
+(void)removeLoaderFromTargetView:(UIView *)listView;
@end

NS_ASSUME_NONNULL_END
