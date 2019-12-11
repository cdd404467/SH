//
//  HomePageModel.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HomePageModel.h"


@implementation HomePageModel

- (BOOL) isPullDown {
    if (!_isPullDown) {
        _isPullDown = NO;
    }
    return _isPullDown;
}
@end

