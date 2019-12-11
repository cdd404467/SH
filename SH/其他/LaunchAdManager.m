//
//  LaunchAdManager.m
//  SH
//
//  Created by i7colors on 2019/10/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "LaunchAdManager.h"
#import <XHLaunchAd.h>
#import "NetTool.h"
#import "BannerModel.h"

@implementation LaunchAdManager
+(void)load {
    
//    [self shareManager];
}

+ (LaunchAdManager *)shareManager {
    static LaunchAdManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        
        instance = [[LaunchAdManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
          
            [self setupXHLaunchAd];
        }];
    }
    return self;
}

- (void)setupXHLaunchAd {
    [self launchWithImageFromNet];
}

-(void)launchWithImageFromNet {
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:3];
    
//    DDWeakSelf;
//
//
//
//    NSString *urlString = @"https://i7apptest.i7colors.com/app-web/index/getBanner?sign=15ceb6c432147774eb93c04a3e77f9fe&plate_code=APP_Start_Pic";
//
//    [NetTool getR:urlString Params:nil Success:^(id json) {
//        NSLog(@"ad---- %@",json);
//        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//            NSArray<BannerModel *> *tempArr = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
//            if (tempArr.count > 0) {
//                BannerModel *model = tempArr[0];
//                if (isRightData(model.ad_image)) {
//                    [weakself setAdConfigure:model];
//                }
//            }
//        }
//    } Failure:^(NSError *error) {
//        NSLog(@"-------error   %@",error);
//    }];

}
- (void)setAdConfigure:(BannerModel *)model {
    
    NSString *imageStr = [NSString stringWithFormat:@"http://static1.i7colors.com%@",model.ad_image];
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [[XHLaunchImageAdConfiguration alloc] init];
    //广告停留时间
    imageAdconfiguration.duration = 3;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    imageAdconfiguration.imageNameOrURLString = imageStr;
    //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
    imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    imageAdconfiguration.GIFImageCycleOnce = NO;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
//    model.ad_url = @"http://www.it7090.com";
    
    imageAdconfiguration.openModel = model;
    
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeRoundProgressText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}



#pragma mark - XHLaunchAd delegate - 倒计时回调
/**
 *  倒计时回调
 *
 *  @param launchAd XHLaunchAd
 *  @param duration 倒计时时间
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration{
    //设置自定义跳过按钮时间
    UIButton *button = (UIButton *)customSkipView;//此处转换为你之前的类型
    //设置时间
    [button setTitle:[NSString stringWithFormat:@"自定义%lds",(long)duration] forState:UIControlStateNormal];
}

#pragma mark - XHLaunchAd delegate - 其他
/**
 广告点击事件回调
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
//    NSLog(@"广告点击事件  -- %@",openModel);
    
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    if(openModel == nil) return;
//    [VCJump jumpToWithADModel:(BannerModel *)openModel];
}

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  XHLaunchAd
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData{
    
//    NSLog(@"图片下载完成/或本地图片读取完成回调");
}

/**
 *  视频本地读取/或下载完成回调
 *
 *  @param launchAd XHLaunchAd
 *  @param pathURL  视频保存在本地的path
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL{
    
//    NSLog(@"video下载/加载完成 path = %@",pathURL.absoluteString);
}

/**
 *  视频下载进度回调
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current{
    
//    NSLog(@"总大小=%lld,已下载大小=%lld,下载进度=%f",total,current,progress);
}

/**
 *  广告显示完成
 */
-(void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd{
    
//    NSLog(@"广告显示完成");
}

@end


