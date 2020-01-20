//
//  ArtistWorksModel.h
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RichTextModel;
NS_ASSUME_NONNULL_BEGIN

@interface ArtistWorksModel : NSObject
//作品图片
@property (nonatomic, copy) NSString *originalUrl;
//价格
@property (nonatomic, copy) NSString *priceShow;
//创作日期
@property (nonatomic, copy) NSString *gmtCreate;
//规格
@property (nonatomic, copy) NSString *specs;
//作品名字
@property (nonatomic, copy) NSString *originalName;
//作品ID
@property (nonatomic, copy) NSString *worksID;

@end

@interface ArtistWorksDetailModel : NSObject
//作品名字
@property (nonatomic, copy) NSString *originalName;
//价格
@property (nonatomic, copy) NSString *priceShow;
//规格
@property (nonatomic, copy) NSString *specs;
//文本
@property (nonatomic, strong) RichTextModel *richText;
@end

@interface RichTextModel : NSObject
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
