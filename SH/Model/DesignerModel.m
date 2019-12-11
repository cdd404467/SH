//
//  DesignerModel.m
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DesignerModel.h"

@implementation DesignerModel

- (NSArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [self.labelNames componentsSeparatedByString:@","];
    }
    return _labelArray;
}

@end

@implementation FinishedWorkModel


@end

@implementation DynamicImgModel


@end

@implementation DynamicStateModel


@end
