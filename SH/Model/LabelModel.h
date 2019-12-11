//
//  LabelModel.h
//  SH
//
//  Created by i7colors on 2019/11/27.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelModel : NSObject
//标签名字
@property (nonatomic, copy) NSString *name;
//标签id
@property (nonatomic, copy) NSString *labelId;
@end

@interface LabelSelectModel : NSObject
//标签名字
@property (nonatomic, copy) NSString *name;
//lab ID
@property (nonatomic, copy) NSString *labelId;
//是否选中
@property (nonatomic, assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
