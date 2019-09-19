//
//  HomeSectionHeader.h
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickMoreBlock)(void);
@interface HomeSectionHeader : UICollectionReusableView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy)ClickMoreBlock clickMoreBlock;
@property (nonatomic, assign) BOOL showMoreBtn;
@end

NS_ASSUME_NONNULL_END
