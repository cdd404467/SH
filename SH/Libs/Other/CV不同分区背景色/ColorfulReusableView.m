//
//  ColorfulReusableView.m
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ColorfulReusableView.h"
#import "ColorfulLayoutAttributes.h"

@implementation ColorfulReusableView
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[ColorfulLayoutAttributes class]]) {
        ColorfulLayoutAttributes *attr = (ColorfulLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attr.backgroundColor;
    }
}
@end
