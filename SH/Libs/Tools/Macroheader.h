//
//  Macroheader.h
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#ifndef Macroheader_h
#define Macroheader_h

#import "UIColor+Hex.h"
#import "UIImage+Color.h"
#import "QuickTool.h"


#define PlaceHolderImg [UIImage imageNamed:@"app_icon"]

//十六进制颜色转换
#define HEXColor(string,alpha) [UIColor colorWithHexString:(string) andAlpha:(alpha)]
//RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBA_F(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
//全局主题色
#define MainColor [UIColor colorWithHexString:@"#FF5100"]
#define Like_Color HEXColor(@"#ededed", 1)
//#define ImgUrl_SD(urlStr) [NSURL URLWithString:urlStr]
#define ImgUrl_SD_OSS(urlStr,width) [NSURL URLWithString:[urlStr stringByAppendingString:[NSString stringWithFormat:@"?x-oss-process=image/resize,w_%d",width]]]
#define MainBgColor HEXColor(@"#F6F6F6", 1)

// 适配宽比例
#define Scale_W [UIScreen mainScreen].bounds.size.width / 375.f
#define KFit_W(variate) ceil(Scale_W * variate)
//屏幕大小
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
//屏幕的宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//系统版本
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//判断是否是iPhoneX系列
#define iPhoneX (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? YES : NO)

/*** 适配iPhoneX 顶部和底部 ***/
//返回状态栏高度
#define STATEBAR_HEIGHT UIApplication.sharedApplication.statusBarFrame.size.height
//返回tabbar的高度
#define TABBAR_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
//返回导航栏高度
#define NAV_HEIGHT (iPhoneX ? 88.f : 64.f)
//顶部高度差
#define Top_Height_Dif (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? 24.f: 0.f)
//底部高度差
#define Bottom_Height_Dif (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? 34.f : 0.f)


//判断后台返回数据是合法的
#define isRightData(jsonData) (jsonData && ![jsonData isEqualToString:@""] && ![jsonData isEqualToString:@"null"] && ![jsonData isEqualToString:@"<null>"] && jsonData != NULL && ![jsonData isKindOfClass:[NSNull class]])
//判断后台返回数据是不合法的
#define isNotRightData(jsonData) (!jsonData || [jsonData isEqualToString:@""]  || [jsonData isEqualToString:@"null"] || [jsonData isEqualToString:@"<null>"] || jsonData == NULL || [jsonData isKindOfClass:[NSNull class]])
//转换字符串
#define To_String(code) [NSString stringWithFormat:@"%@", code]

//weakself 和 strongself
#define DDWeakSelf __weak typeof(self) weakself = self;
#define DDStrongSelf __weak typeof(self) strongself = self;


#pragma mark - 本地存储
/*********   本地存储   *********/
//NSUserDefaults
#define UserDefault [NSUserDefaults standardUserDefaults]
//存储的手机号
#define User_Phone [UserDefault objectForKey:@"userPhoneNumber"]
//判断userToken
#define Get_User_Token [User_Info objectForKey:@"userToken"]
//存储的token
#define User_Token ([UserDefault objectForKey:@"userToken"] ? [UserDefault objectForKey:@"userToken"] : @"")





#pragma mark - quickTool的快捷结果
//判断是不是模拟器
#define isSimuLator [QuickTool is_SimuLator]
//判断是否是debug模式
#define isDebug [QuickTool is_Debug]
//navBar的高度
#define NavBarHeight [QuickTool navBarHeight]

#endif /* Macroheader_h */
