//
//  ArtistWorksTBCell.h
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArtistWorksModel;
NS_ASSUME_NONNULL_BEGIN

@interface ArtistWorksTBCell : UITableViewCell
@property (nonatomic, strong) ArtistWorksModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
