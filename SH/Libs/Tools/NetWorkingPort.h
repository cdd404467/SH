//
//  NetWorkingPort.h
//  SH
//
//  Created by i7colors on 2019/9/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#ifndef NetWorkingPort_h
#define NetWorkingPort_h



#define PageCount 20
#define Server_Api @"https://yaochengkun-shanghu.f.wmeimob.com/api/"

//根据手机号获取token
#define URLGet_Token_PhoneNumber @"login/phone?&mobile=%@"




//获取首页数据
#define URLGet_Index_Data @"index"
//首页搜索
#define URLGet_Index_SearchAppoint @"index/search?&type=%d&searchName=%@&sortType=%d&idList=%@&pageSize=%d&pageIndex=%d"


#pragma mark - 商品
//查看所有商品分类
#define URLGet_All_Classify @"goodsClassify/all/classify"

//查看分类商品列表
#define URLGet_Goods_ClassifyList @"goods/classify?&classifyId=%d&sortType=%d&pageSize=%d&pageIndex=%d"

//查看商品详情
#define URLGet_Goods_Details @"goods/1?&id=%d"

#endif /* NetWorkingPort_h */
