//
//  MaterialListView.h
//  SH
//
//  Created by i7colors on 2019/11/27.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaterialListView : UIView

@property (nonatomic, assign) NSInteger line;
@property (nonatomic, assign) CGFloat gap;
@property (nonatomic, assign) NSInteger rows;
//@property (nonatomic, copy) ClickBlock clickBlock;
@property (nonatomic, copy) NSArray *dataSource;
@end

NS_ASSUME_NONNULL_END
