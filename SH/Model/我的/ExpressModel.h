//
//  ExpressModel.h
//  SH
//
//  Created by i7colors on 2020/1/3.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpressModel : NSObject
//物流信息
@property (nonatomic, copy) NSString *AcceptStation;
//物流到此处的时间
@property (nonatomic, copy) NSString *AcceptTime;
//cell height
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
