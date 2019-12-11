//
//  NetWorkingPort.h
//  SH
//
//  Created by i7colors on 2019/9/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#ifndef NetWorkingPort_h
#define NetWorkingPort_h


//#define _PRODUCTION_NETWORK
//#define _XCX_TEST_NETWORK
#define _ZJG_TEST_NETWORK



#ifdef _PRODUCTION_NETWORK

#else
#ifdef _XCX_TEST_NETWORK
#define Server_Api @"https://xcxtest.shanghusm.com/api/"
#else
#define Server_Api @"http://zjgweb.imdo.co:34451/api/"
#endif
#endif




#define PageCount 20

//根据手机号获取token
#define URLGet_Token_PhoneNumber @"login/phone?&mobile=%@"


//获取首页数据
#define URLGet_Index_Data @"index"
//首页搜索
#define URLGet_Index_SearchAppoint @"index/search?&type=%d&searchName=%@&sortType=%d&idList=%@&pageSize=%d&pageIndex=%d"

#pragma mark - 商品,场景,素材
//查看所有商品分类
#define URLGet_All_Classify @"goodsClassify/all/classify"
//场景详情
#define URLGet_Scene_Detail @"scene/%d"
//场景详情下商品和素材列表
#define URLGet_Scene_Detail_List @"scene/detail?&sceneId=%d&type=%d&sortType=%d&pageSize=%d&pageIndex=%d"
//查看分类商品列表
#define URLGet_Goods_ClassifyList @"goods/classify?&classifyId=%d&sortType=%d&pageSize=%d&pageIndex=%d"
//查看商品详情
#define URLGet_Goods_Details @"goods/%d"
//查看素材详情
#define URLGet_Material_Details @"goods/material/%@"
//查看素材标签列表
#define URLGet_Material_Labs @"index/label"


#pragma mark - 设计师
//查看设计师首页
#define URLGet_DesignerMain_Info @"designer/info?&isSelf=%@&designerId=%@"
//设计师主页素材
#define URLGet_DesignerMain_MaterialList @"designer/material?&isSelf=%@&designerId=%@&pageSize=%d&pageIndex=%d"
//设计师成品
#define URLGet_DesignerMain_FinishedProductList @"designer/works?&isSelf=%@&designerId=%@"
//设计师动态
#define URLGet_DesignerMain_DynamicState @"designer/trends?&isSelf=%@&designerId=%@&pageSize=%d&pageIndex=%d"


//查看商品所有评价
#define URLGet_Goods_Evaluation @"goods/evaluate?&goodsId=%d&pageSize=%d&pageIndex=%d"

#pragma mark - 购物车
//获取购物车
#define URLGet_Shop_Car_List @"goods/car"
//加入购物车
#define URLPost_Add_ShopCar @"goods/car"

#pragma mark - 收货地址
//地址列表
#define URLGet_Address_List @"user/address/getList"
//查看单条地址
#define URLGet_Single_Address @"user/address/%d"
//新增收货地址
#define URLGet_Add_Address @"user/address/add"

#endif /* NetWorkingPort_h */
