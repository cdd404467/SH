//
//  AddressModel.h
//  SH
//
//  Created by i7colors on 2019/12/11.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject
//手机号
@property (nonatomic, copy) NSString *phone;
//名字
@property (nonatomic, copy) NSString *name;
//地址
@property (nonatomic, copy) NSString *address;
//是否默认地址
@property (nonatomic, assign) NSInteger defaultStatus;
//收货地址id
@property (nonatomic, assign) int addressID;
//省
@property (nonatomic, copy) NSString *provinceName;
//市
@property (nonatomic, copy) NSString *cityName;
//区
@property (nonatomic, copy) NSString *districtName;

//省id
@property (nonatomic, copy) NSString *provinceId;
//市id
@property (nonatomic, copy) NSString *cityId;
//区id
@property (nonatomic, copy) NSString *districtId;

@end

NS_ASSUME_NONNULL_END
