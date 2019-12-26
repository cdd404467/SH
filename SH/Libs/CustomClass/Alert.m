//
//  Alert.m
//  SH
//
//  Created by i7colors on 2019/12/12.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "Alert.h"

@implementation Alert
//中间弹框,一个按钮
+ (void)alertSystemOne:(NSString *)title okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK {
    [self alertSystemOne:title okBtn:okTitle msg:@"" OKCallBack:OK];
}

//中间弹框,一个按钮
+ (void)alertSystemOne:(NSString *)title okBtn:(NSString *)okTitle  msg:(NSString *)msg  OKCallBack:(void(^)(void))OK {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertString = [[NSMutableAttributedString alloc] initWithString:title];
    [alertString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0, title.length)];
    [alert setValue:alertString forKey:@"attributedTitle"];
    
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OK) {
            OK();
        }
    }];
    //KVC改变按钮颜色
    if (@available(iOS 9.0, *)){
        [okBtn setValue:HEXColor(@"#FF5100", 1) forKey:@"titleTextColor"];
    }
    [alert addAction:okBtn];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

//中间弹框,两个按钮
+ (void)alertSystemTwo:(NSString *)title cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertString = [[NSMutableAttributedString alloc] initWithString:title];
    [alertString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0, title.length)];
    
    [alert setValue:alertString forKey:@"attributedTitle"];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OK) {
            OK();
        }
    }];
    //KVC改变按钮颜色
    if (@available(iOS 9.0, *)){
        [okBtn setValue:HEXColor(@"#FF5100", 1) forKey:@"titleTextColor"];
        [cancelBtn setValue:UIColor.grayColor forKey:@"titleTextColor"];
    }
    [alert addAction:cancelBtn];
    [alert addAction:okBtn];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    });
}

//中间弹框,两个按钮,取消按钮回调
+ (void)alertSystemTwo:(NSString *)title cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle cancelCallBack:(void(^)(void))cancel OKCallBack:(void(^)(void))OK {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertString = [[NSMutableAttributedString alloc] initWithString:title];
    [alertString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0, title.length)];
    
    [alert setValue:alertString forKey:@"attributedTitle"];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel();
        }
    }];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OK) {
            OK();
        }
    }];
    //KVC改变按钮颜色
    if (@available(iOS 9.0, *)){
        [okBtn setValue:HEXColor(@"#FF5100", 1) forKey:@"titleTextColor"];
        [cancelBtn setValue:UIColor.grayColor forKey:@"titleTextColor"];
    }
    [alert addAction:cancelBtn];
    [alert addAction:okBtn];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    });
}
@end
