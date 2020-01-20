//
//  VCJump.m
//  SH
//
//  Created by i7colors on 2020/1/9.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "VCJump.h"
#import "GoodsDetailsVC.h"

@implementation VCJump

#pragma mark - 分享跳转
//分享打开app跳转 - host(m.i7colors.cut)  query(mainId=45&buyerId=383)
+ (void)openShareURLWithHost:(NSString *)host query:(NSString *)query nav:(BaseNavigationController *)nav {
    //商品详情
    if ([host containsString:@"productDetails"]) {
        GoodsDetailsVC *vc = [[GoodsDetailsVC alloc] init];
        NSArray *uIDs = [query componentsSeparatedByString:@"="];
        vc.goodsID = [uIDs[1] intValue];
        [nav pushViewController:vc animated:YES];
    }
}

@end
