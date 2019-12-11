//
//  EditAddressVC.h
//  SH
//
//  Created by i7colors on 2019/12/11.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditAddressVC : BaseViewController
//0是添加地址，1是编辑地址
@property (nonatomic, assign) int editType;
@property (nonatomic, assign) int addressID;
@end

NS_ASSUME_NONNULL_END
