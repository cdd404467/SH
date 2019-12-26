//
//  EditAddressVC.h
//  SH
//
//  Created by i7colors on 2019/12/11.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SaveSuccessBlock)(void);
@interface EditAddressVC : BaseViewController
//0是添加地址，1是编辑地址
@property (nonatomic, assign) int editType;
@property (nonatomic, assign) int addressID;
@property (nonatomic, copy) SaveSuccessBlock saveSuccessBlock;
@end

NS_ASSUME_NONNULL_END
