//
//  CddActionSheetView.m
//  QCY
//
//  Created by i7colors on 2019/4/30.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CddActionSheetView.h"


#define AniTime 0.35
#define BgColor HEXColor(@"#ffffff", 0.44);

static NSString *const sheetViewCell = @"tbCell";

typedef void(^selectBlock)(NSInteger index);
typedef void(^selectBlockAlert)(void);
typedef void(^cancelBlock)(void);
@interface CddActionSheetView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
//选项列表
@property (nonatomic, strong) UITableView *tableView;
//背景
@property (nonatomic, strong) UIView *backView;
//选中回调
@property (nonatomic, copy) selectBlock selectBlock;
//选中回调
@property (nonatomic, copy) selectBlockAlert selectBlockAlert;
//取消回调
@property (nonatomic, copy) cancelBlock cancelBlock;
//文字颜色
@property (nonatomic, strong)UIColor *color;
// 选项高度 默认为56
@property (nonatomic, assign) CGFloat itemHeight;
//标题数组
@property (nonatomic, strong) NSMutableArray <NSArray *>*titlesArray;
//副标题数组
@property (nonatomic, strong) NSArray <NSString *>*subTitlesArray;
@end

@implementation CddActionSheetView

- (instancetype)initWithOptions:(NSArray<NSString *> *)titles completion:(void (^)(NSInteger))completion cancel:(void (^)(void))cancelBlock {
    self = [super init];
    if (self) {
        self.frame = SCREEN_BOUNDS;
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self initialize];
        self.titlesArray = [NSMutableArray arrayWithArray:titles];
        [self.titlesArray addObject:@[@"取消"]];
        self.selectBlock = completion;
        self.cancelBlock = cancelBlock;
        self.color = HEXColor(@"#333333", 1);
    }
    
    return self;
}

- (instancetype)initWithSheetOKTitle:(NSString *)ok cancelTitle:(NSString *)cancel completion:(void (^)(void))completion cancel:(void (^)(void))cancelBlock {
    self = [super init];
    if (self) {
        self.frame = SCREEN_BOUNDS;
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self initialize];
        self.titlesArray = [NSMutableArray arrayWithObjects:@[ok], @[cancel], nil];
        self.selectBlockAlert = completion;
        self.cancelBlock = cancelBlock;
        self.color = HEXColor(@"#e5473e", 1);
    }
    
    return self;
}

- (void)initialize {
    self.itemHeight = 46;
    self.gapHeight = 6;
}

- (UIView *)backView {
    if (!_backView) {
        NSInteger count = 0;
        for (NSArray *arr in self.titlesArray) {
            count += arr.count;
        }
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.itemHeight * count + (self.titlesArray.count - 1) * 6 + Bottom_Height_Dif)];
        _backView.backgroundColor = BgColor;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_backView addSubview:effectView];
        [_backView addSubview:self.tableView];
        _backView.height = _tableView.tableHeaderView.height + _backView.height;
        effectView.frame = CGRectMake(0, 0, _backView.width, _backView.height);
        self.tableView.frame = CGRectMake(0, 0, _backView.width, _backView.height);
    }
    return _backView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (_title && ![_title isEqualToString:@" "]) {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
            header.backgroundColor = BgColor;
            
            UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 20)];
            textLab.text = _title;
            textLab.textAlignment = NSTextAlignmentCenter;
            textLab.numberOfLines = 0;
            textLab.font = [UIFont systemFontOfSize:13];
            textLab.textColor = HEXColor(@"#868686", 1);
            [header addSubview:textLab];
            
            CGFloat height = [_title boundingRectWithSize:CGSizeMake(textLab.width, MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:textLab.font}
                                                              context:nil].size.height;
            header.height = height + 40;
            textLab.height = height + 10;
            textLab.centerY = header.centerY;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header.height - .5, SCREEN_WIDTH, .5)];
            line.backgroundColor = RGBA(195, 195, 195, 1);
            [header addSubview:line];
            _tableView.tableHeaderView = header;
            _tableView.height = _tableView.height + header.height;
            
        }
        _tableView.backgroundColor = BgColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = RGBA(195, 195, 195, 1);
        _tableView.separatorInset = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sheetViewCell];
        if (iPhoneX) {
            UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Bottom_Height_Dif)];
            footer.backgroundColor = BgColor;
            _tableView.tableFooterView = footer;
        }
    }
    
    return _tableView;
}

- (void)show {
    if (self.titlesArray.count < 1) {
        NSLog(@"至少添加一个标题");
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sheetCancelAction)];
    backTap.delegate = self;
    [self addGestureRecognizer:backTap];
    [self addSubview:self.backView];
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        self.backView.top = SCREEN_HEIGHT - self.backView.height;
    }];
}

//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titlesArray.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray[section].count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemHeight;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    } else {
        return self.gapHeight;
    }
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == self.titlesArray.count - 1) {
        [self sheetCancelAction];
    } else {
        if (self.selectBlock) {
            self.selectBlock(indexPath.row);
        }
        if (self.selectBlockAlert) {
            self.selectBlockAlert();
        }
        [self removeViews];
    }
}

//TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = HEXColor(@"#ffffff", 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sheetViewCell];
    cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = BgColor;
    if (indexPath.section == self.titlesArray.count - 1) {
        cell.textLabel.textColor = HEXColor(@"#333333", 1);
    } else {
        cell.textLabel.textColor = self.color;
    }
    
    return cell;
}

- (void)sheetCancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    [self removeViews];
}

- (void)removeViews {
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        self.backView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
    }
    
    if (touch.view.height < SCREEN_HEIGHT - 10) {
        return NO;
    }
    
    return YES;
}

@end
