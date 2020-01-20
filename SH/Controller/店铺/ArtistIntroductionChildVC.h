//
//  ArtistIntroductionChildVC.h
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "BaseViewController.h"
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtistIntroductionChildVC : BaseViewController<JXPagerViewListViewDelegate>
@property (nonatomic, copy) NSString *synopsisID;
@end

NS_ASSUME_NONNULL_END
