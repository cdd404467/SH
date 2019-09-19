//
//  HomeSceneCVCell.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HomeSceneCVCell.h"
#import "SceneView.h"
#import "SceneModel.h"

@interface HomeSceneCVCell()
@property (nonatomic, strong) SceneView *sceneView;
@end

@implementation HomeSceneCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    SceneView *sceneView = [[SceneView alloc] init];
    [self.contentView addSubview:sceneView];
    [sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _sceneView = sceneView;
}

- (void)setModel:(SceneModel *)model {
    _model = model;
    _sceneView.model = model;
}

@end
