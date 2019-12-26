//
//  SearchResultSecHeader.h
//  SH
//
//  Created by i7colors on 2019/12/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MoreBtnClick)(void);
@interface SearchResultSecHeader : UICollectionReusableView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) MoreBtnClick moreBtnClick;
@end

NS_ASSUME_NONNULL_END
