//
//  ExpressModel.m
//  SH
//
//  Created by i7colors on 2020/1/3.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ExpressModel.h"

@implementation ExpressModel
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 40;
    }
    return _cellHeight;
}
@end
