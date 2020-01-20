//
//  NetWorkingPort.h
//  SH
//
//  Created by i7colors on 2019/9/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#ifndef NetWorkingPort_h
#define NetWorkingPort_h


#define _PRODUCTION_NETWORK
//#define _XCX_TEST_NETWORK
//#define _ZJG_TEST_NETWORK



#ifdef _PRODUCTION_NETWORK
#define Server_Api @"https://xcx.shanghusm.com/api/"
#else
#ifdef _XCX_TEST_NETWORK
#define Server_Api @"https://xcxtest.shanghusm.com/api/"
#else
#define Server_Api @"http://192.168.11.110:8081/api/"
#endif
#endif




#define PageCount 40

//版本检测
#define URLGet_Check_Update @"login/edition?editionNum=%@&equipmentType=%d"

//根据手机号获取token
#define URLGet_Token_PhoneNumber @"login/phone?mobile=%@"
//获取短信验证码
#define URLGet_SMS_Code @"login/code?mobile=%@"
//登录注册
#define URLPost_Login_Register @"login/sign"

//获取首页数据
#define URLGet_Index_Data @"index"
//首页指定搜索
#define URLGet_Index_SearchAppoint @"index/search?type=%d&searchName=%@&sortType=%d&idList=%@&pageSize=%d&pageIndex=%d"
#define URLGet_Index_SearchAllKinds @"index/search/all?searchName=%@"


#pragma mark - 商品
//查看所有商品分类
#define URLGet_All_Classify @"goodsClassify/all/classify"
//查看分类商品列表
#define URLGet_Goods_ClassifyList @"goods/classify?classifyId=%@&sortType=%d&pageSize=%d&pageIndex=%d"
//查看商品详情
#define URLGet_Goods_Details @"goods/detail?goodsId=%d"
//查看商品所有评价
#define URLGet_Goods_Evaluation @"goods/evaluate?goodsId=%d&pageSize=%d&pageIndex=%d"


#pragma mark - 场景
//场景详情
#define URLGet_Scene_Detail @"scene/%d"
//场景详情下商品和素材列表
#define URLGet_Scene_Detail_List @"scene/detail?sceneId=%d&type=%d&sortType=%d&pageSize=%d&pageIndex=%d"


#pragma mark - 素材
//查看素材详情
#define URLGet_Material_Details @"goods/material/%@"
//查看素材标签列表
#define URLGet_Material_Labs @"index/label"


#pragma mark - 店铺
//查看店铺标签列表
#define URLGet_Shop_Labs @"shop/label"
//店铺主页
#define URLGet_Shop_HomePage @"shop?isSelf=%@&shopId=%@"
//店铺主页下面的商品列表
#define URLGet_ShopHomePage_GoodsList @"shop/goods?classifyId=%@&sortType=%d"
//艺术家店铺简介
#define URLGet_ArtistShop_intro @"shop/synopsis?synopsisId=%@"
//艺术家店铺的作品分类
#define URLGet_ArtistShop_WorksClassifys @"shop/originalClassifys?shopId=%@"
//艺术家店铺的作品列表
#define URLGet_ArtistShop_WorksList @"shop/artistOriginal?classifysId=%@"
//店铺详情
#define URLGet_ArtistWorks_Details @"shop/artistOriginalDetail?id=%@"


#pragma mark - 收藏
//收藏
#define URLPost_Collect @"collect"
//取消收藏
#define URLPut_Cancel_Collect @"collect"
//查看用户收藏
#define URLGet_User_CollectList @"collect/?type=%@&pageSize=%d&pageIndex=%d"

#pragma mark - 设计师
//查看设计师首页
#define URLGet_DesignerMain_Info @"designer/info?isSelf=%@&designerId=%@"
//设计师主页素材
#define URLGet_DesignerMain_MaterialList @"designer/material?isSelf=%@&designerId=%@&pageSize=%d&pageIndex=%d"
//设计师成品
#define URLGet_DesignerMain_FinishedProductList @"designer/works?isSelf=%@&designerId=%@"
//设计师动态
#define URLGet_DesignerMain_DynamicState @"designer/trends?isSelf=%@&designerId=%@&pageSize=%d&pageIndex=%d"


#pragma mark - 购物车
//获取购物车
#define URLGet_Shop_Car_List @"goods/car"
//加入购物车
#define URLPost_Add_ShopCar @"goods/car"
//改变购物车数量
#define URLPut_Change_ShopCar @"goods/car"
//删除购物车
#define URLPut_Delete_ShopCar @"goods/car/del"
//查看购物车数量
#define URLGet_ShopCar_Num @"goods/car/num"

#pragma mark - 收货地址
//地址列表
#define URLGet_Address_List @"user/address/getList"
//查看单条地址
#define URLGet_Single_Address @"user/address/%d"
//新增收货地址
#define URLPost_Add_Address @"user/address/add"
//修改收货地址
#define URLPut_Update_Address @"user/address/update"
//删除一条地址
#define URLPut_Delete_Address @"user/address/delete"


#pragma mark - 发票
//发票列表
#define URLGet_Invoice_List @"user/invoice/getList"
//新增发票
#define URLPost_Add_Invoice @"user/invoice/add"
//编辑发票
#define URLPut_Update_Invoice @"user/invoice/update"
//删除发票
#define URLPut_Delete_Invoice @"user/invoice/delete"


#pragma mark - 订单相关
//查询运费
#define URLPut_Freight_Pay @"goods/pay/getRreight"
//下单
#define URLPost_Pay_Money @"goods/pay"
//获取下单信息
#define URLPut_Order_PayInfo @"goods/getPayInfo"
//订单列表
#define URLGet_Order_List @"order/getOrderList?orderStatus=%@&pageSize=%d&pageIndex=%d"
//删除订单
#define URLPut_Order_Delete @"order/delOrder"
//取消订单
#define URLPut_Order_Cancel @"order/cancelOrder"
//确认收货
#define URLPut_Order_Confirm @"order/confirmOrder"
//订单号付款
#define URLPost_OrderNo_Pay @"goods/pay/orderNo"
//订单详情
#define URLGet_Order_Detail @"order/%@"
//查看物流
#define URLGet_Order_Express @"order/express?expressCode=%@&expressNumber=%@"
#endif /* NetWorkingPort_h */
