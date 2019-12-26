//
//  ReceiverAddressVC.h
//  SH
//
//  Created by i7colors on 2019/12/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"

@class AddressModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectAddressBlock)(AddressModel *model);
@interface ReceiverAddressVC : BaseViewController
@property (nonatomic, copy) SelectAddressBlock selectAddressBlock;
@property (nonatomic, copy) NSString *navTitle;
@end

NS_ASSUME_NONNULL_END
