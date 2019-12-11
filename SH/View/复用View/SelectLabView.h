//
//  SelectLabView.h
//  SH
//
//  Created by i7colors on 2019/12/5.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LabelSelectModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^CompleteBlock)(NSString *labsID);
@interface SelectLabView : UIView
@property (nonatomic, copy) NSMutableArray *dataSource;
@property (nonatomic, copy) CompleteBlock completeBlock;
- (void)show;
@end

@interface CustomLabsCell : UICollectionViewCell
@property (nonatomic, strong) LabelSelectModel *model;
@end

NS_ASSUME_NONNULL_END

