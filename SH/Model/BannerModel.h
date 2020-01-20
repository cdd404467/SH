//
//  BannerModel.h
//  SH
//
//  Created by i7colors on 2019/9/20.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject
//图片
@property (nonatomic, copy) NSString *banner;
//id
@property (nonatomic, copy) NSString *bannerID;
//轮播图类型 1 商品详情 2 商品分类 3场景详情 4设计师首页 5商家首页
@property (nonatomic, copy) NSString *type;
//跳转的相应id
@property (nonatomic, copy) NSString *typeId;
//艺术家店铺banner的id
@property (nonatomic, copy) NSString *shopId;






//轮播图片
@property (nonatomic, copy) NSString *ad_image;
//活动名字
@property (nonatomic, copy) NSString *plate_code;
//活动名字
@property (nonatomic, copy) NSString *ad_name;
//活动链接
@property (nonatomic, copy) NSString *ad_url;
//广告类型，type=inner内部跳转。type=html外链。如果type= null则是默认外部链接。链接也可能为空
//@property (nonatomic, copy) NSString *type;
//跳转模块，enquiry求购，groupBuy团购，auction抢购，market店铺，product产品，information资讯,zhuji助剂定制
@property (nonatomic, copy) NSString *directType;
//模块id，如果为空，则是跳转列表
@property (nonatomic, copy) NSString *directTypeId;
@end

NS_ASSUME_NONNULL_END
