//
//  ArtistWorksModel.m
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ArtistWorksModel.h"

@implementation ArtistWorksModel
//转换,前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"worksID" : @"id",
             };
}
@end

@implementation ArtistWorksDetailModel


@end

@implementation RichTextModel


@end
