//
//  EditInvoiceVC.m
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "EditInvoiceVC.h"
#import "UIView+Border.h"
#import "UITextField+Limit.h"
#import <BRPickerView.h>
#import "CddHud.h"
#import "NetTool.h"
#import "InvoiceModel.h"

@interface EditInvoiceVC ()
@property (nonatomic, strong) UIButton *commonBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *vatBtn;
@property (nonatomic, strong) UIScrollView *commonScrollView;
@property (nonatomic, strong) UIScrollView *vatScrollView;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UITextField *titleTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UISwitch *defaultSwitch;

//增值发票
@property (nonatomic, strong) UITextField *s_nameTF;
@property (nonatomic, strong) UITextField *s_ratepayerTF;
@property (nonatomic, strong) UITextField *s_registerAddressTF;
@property (nonatomic, strong) UITextField *s_registerPhoneTF;
@property (nonatomic, strong) UITextField *s_bankTF;
@property (nonatomic, strong) UITextField *s_bankAccountTF;
@property (nonatomic, strong) UITextField *s_nickNameTF;
@property (nonatomic, strong) UITextField *s_addressTF;
@property (nonatomic, strong) UISwitch *s_defaultSwitch;
@end

@implementation EditInvoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = self.editType == 0 ? @"新增发票" : @"编辑发票";
    [self setupUI];
}

- (UIScrollView *)vatScrollView {
    if (!_vatScrollView) {
        _vatScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 49, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 49)];
        _vatScrollView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _vatScrollView.bounces = NO;
        _vatScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 12 * 50 + 30);
        _vatScrollView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return _vatScrollView;
}

- (UIScrollView *)commonScrollView {
    if (!_commonScrollView) {
        _commonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 49, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 49)];
        _commonScrollView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _commonScrollView.bounces = NO;
        _vatScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 5 * 50 + 38);
        _commonScrollView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    }
    return _commonScrollView;
}

- (void)commonBtnClick {
    [self.view endEditing:YES];
    _commonBtn.selected = YES;
    _vatBtn.selected = NO;
    _commonScrollView.hidden = NO;
    _vatScrollView.hidden = YES;
}

- (void)vatBtnClick {
    [self.view endEditing:YES];
    _commonBtn.selected = NO;
    _vatBtn.selected = YES;
    _commonScrollView.hidden = YES;
    _vatScrollView.hidden = NO;
}

- (void)setupUI {
    _commonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commonBtn.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH / 2, 49);
    [_commonBtn setTitle:@"普通发票(电子)" forState:UIControlStateNormal];
    [_commonBtn setTitleColor:HEXColor(@"#9B9B9B", 1) forState:UIControlStateNormal];
    [_commonBtn setTitleColor:HEXColor(@"#090203", 1) forState:UIControlStateSelected];
    _commonBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_commonBtn addTarget:self action:@selector(commonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commonBtn];
    [_commonBtn addBorder:Line_Color width:0.5 direction:BorderDirectionBottom];
    
    _vatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_vatBtn addTarget:self action:@selector(vatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _vatBtn.frame = CGRectMake(SCREEN_WIDTH / 2, NAV_HEIGHT, SCREEN_WIDTH / 2, 49);
    [_vatBtn setTitle:@"增值税专用发票" forState:UIControlStateNormal];
    [_vatBtn setTitleColor:HEXColor(@"#9B9B9B", 1) forState:UIControlStateNormal];
    [_vatBtn setTitleColor:HEXColor(@"#090203", 1) forState:UIControlStateSelected];
    _vatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_vatBtn];
    [_vatBtn addBorder:Line_Color width:0.5 direction:BorderDirectionBottom];
    
    [self.view addSubview:self.commonScrollView];
    [self.view addSubview:self.vatScrollView];
    
    [self setScrol_1];
    [self setScrol_2];
    
    if (_editType == 0) {
        _commonBtn.selected = YES;
        _vatScrollView.hidden = YES;
        _typeLab.text = @"个人";
    } else {
        //普通发票
        if (_model.invoiceType == 1) {
            _commonBtn.selected = YES;
            _vatScrollView.hidden = YES;
            _titleTF.text = _model.title;
            _phoneTF.text = _model.mobile;
            _defaultSwitch.on = _model.defaultStatus == 0 ? NO : YES;
        } else {
            _vatBtn.selected = YES;
            _commonScrollView.hidden = YES;
            _s_nameTF.text = _model.enterpriseName;
            _s_ratepayerTF.text = _model.taxCode;
            _s_registerAddressTF.text = _model.loginAddress;
            _s_registerPhoneTF.text = _model.mobile;
            _s_bankTF.text = _model.bankName;
            _s_bankAccountTF.text = _model.account;
            _s_nickNameTF.text = _model.nickname;
            _s_addressTF.text = _model.address;
            _s_defaultSwitch.on = _model.defaultStatus == 0 ? NO : YES;
        }
        _typeLab.text = _model.normalType == 1 ? @"个人" : @"企业";
    }
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.layer.cornerRadius = 20.f;
    _saveBtn.clipsToBounds = YES;
    _saveBtn.adjustsImageWhenHighlighted = false;
    [_saveBtn addTarget:self action:@selector(saveInvoice) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-Bottom_Height_Dif - 8);
    }];
    [_saveBtn.superview layoutIfNeeded];
    [_saveBtn setBackgroundImage:[HelperTool globalGradientColor:_saveBtn.bounds] forState:UIControlStateNormal];
}

- (void)saveInvoice {
    if (_editType == 0) {
        [self addSubmit];
    } else if (_editType == 1) {
        [self editSubmit];
    }
}

- (void)addSubmit {
    if (![self judgeInfo]) {
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionary];
    if (_commonBtn.selected) {
        int type = 1;
        if ([_typeLab.text isEqualToString:@"个人"]) {
            type = 1;
        } else {
            type = 2;
        }
        dict = @{@"normalType":@(type),
                 @"invoiceType":_commonBtn.selected == YES ? @1 : @2,
                 @"title":_titleTF.text.length == 0 ? @"个人" : _titleTF.text,
                 @"mobile":_phoneTF.text,
                 @"defaultStatus":@(_defaultSwitch.on == YES ? 1 : 0),
                 @"content":@"商品明细",
                 @"taxCode":@"",
                 @"loginAddress":@"",
                 @"enterpriseName":@"",
                 @"address":@"",
                 @"nickname":@"",
                 @"bankName":@"",
                 @"account":@"",
        };
    } else if (_vatBtn.selected) {
        dict = @{@"normalType":@0,
                 @"invoiceType":_commonBtn.selected == YES ? @1 : @2,
                 @"title":_s_nameTF.text,
                 @"mobile":_s_registerPhoneTF.text,
                 @"defaultStatus":@(_s_defaultSwitch.on == YES ? 1 : 0),
                 @"content":@"商品明细",
                 @"taxCode":_s_ratepayerTF.text,
                 @"loginAddress":_s_registerAddressTF.text,
                 @"enterpriseName":_s_nameTF.text,
                 @"address":_s_addressTF.text,
                 @"nickname":_s_nickNameTF.text,
                 @"bankName":_s_bankTF.text,
                 @"account":_s_bankAccountTF.text,
        };
    }
 
    __block MBProgressHUD *hud = [CddHud show:self.view];
    self.commonScrollView.userInteractionEnabled = NO;
    self.vatScrollView.userInteractionEnabled = NO;
    self.saveBtn.userInteractionEnabled = NO;
    [NetTool postRequest:URLPost_Add_Invoice Params:dict Success:^(id  _Nonnull json) {
        [CddHud showSwitchText:hud text:@"保存成功"];
        self.commonScrollView.userInteractionEnabled = YES;
        self.vatScrollView.userInteractionEnabled = YES;
        self.saveBtn.userInteractionEnabled = YES;
        if (self.saveSuccessBlock) {
            self.saveSuccessBlock();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } Error:^(id  _Nullable json) {
        
    } Failure:^(NSError * _Nonnull error) {

    }];
}

//编辑发票
- (void)editSubmit {
    if (![self judgeInfo]) {
           return;
       }
       
       NSDictionary *dict = [NSDictionary dictionary];
       if (_commonBtn.selected) {
           int type = 1;
           if ([_typeLab.text isEqualToString:@"个人"]) {
               type = 1;
           } else {
               type = 2;
           }
           dict = @{@"id":_model.invoiceID,
                    @"normalType":@(type),
                    @"invoiceType":_commonBtn.selected == YES ? @1 : @2,
                    @"title":_titleTF.text.length == 0 ? @"个人" : _titleTF.text,
                    @"mobile":_phoneTF.text,
                    @"defaultStatus":@(_defaultSwitch.on == YES ? 1 : 0),
                    @"content":@"商品明细",
                    @"taxCode":@"",
                    @"loginAddress":@"",
                    @"enterpriseName":@"",
                    @"address":@"",
                    @"nickname":@"",
                    @"bankName":@"",
                    @"account":@"",
           };
       } else if (_vatBtn.selected) {
           dict = @{@"id":_model.invoiceID,
                    @"normalType":@0,
                    @"invoiceType":_commonBtn.selected == YES ? @1 : @2,
                    @"title":_s_nameTF.text,
                    @"mobile":_s_registerPhoneTF.text,
                    @"defaultStatus":@(_s_defaultSwitch.on == YES ? 1 : 0),
                    @"content":@"商品明细",
                    @"taxCode":_s_ratepayerTF.text,
                    @"loginAddress":_s_registerAddressTF.text,
                    @"enterpriseName":_s_nameTF.text,
                    @"address":_s_addressTF.text,
                    @"nickname":_s_nickNameTF.text,
                    @"bankName":_s_bankTF.text,
                    @"account":_s_bankAccountTF.text,
           };
       }
    
       __block MBProgressHUD *hud = [CddHud show:self.view];
       self.commonScrollView.userInteractionEnabled = NO;
       self.vatScrollView.userInteractionEnabled = NO;
       self.saveBtn.userInteractionEnabled = NO;
       [NetTool putRequest:URLPut_Update_Invoice Params:dict Success:^(id  _Nonnull json) {
           [CddHud showSwitchText:hud text:@"修改成功"];
           self.commonScrollView.userInteractionEnabled = YES;
           self.vatScrollView.userInteractionEnabled = YES;
           self.saveBtn.userInteractionEnabled = YES;
           if (self.saveSuccessBlock) {
               self.saveSuccessBlock();
           }
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self.navigationController popViewControllerAnimated:YES];
           });
       } Error:nil Failure:^(NSError * _Nonnull error) {

       }];
}

- (BOOL)judgeInfo {
    //普通发票
    if (_commonBtn.selected) {
        if (_phoneTF.text.length == 0) {
            [CddHud showTextOnly:@"请填写手机号" view:self.view];
            return NO;
        } else if (_phoneTF.text.length < 11) {
            [CddHud showTextOnly:@"请填写正确的手机号" view:self.view];
            return NO;
        } else if (_phoneTF.text.length > 1 && [_phoneTF.text substringToIndex:1].intValue != 1) {
            [CddHud showTextOnly:@"请填写正确的手机号" view:self.view];
            return NO;
        }
        return YES;
    } else if (_vatBtn.selected) {
        if (_s_nameTF.text.length < 1) {
            [CddHud showTextOnly:@"请填写单位名称" view:self.view];
            return NO;
        } else if (_s_registerAddressTF.text.length == 0) {
            [CddHud showTextOnly:@"请填写注册地址" view:self.view];
            return NO;
        } else if (_s_registerPhoneTF.text.length == 0) {
            [CddHud showTextOnly:@"请填写注册电话" view:self.view];
            return NO;
        } else if (_s_registerPhoneTF.text.length < 11) {
            [CddHud showTextOnly:@"请填写正确的注册电话" view:self.view];
            return NO;
        } else if (_s_registerPhoneTF.text.length > 1 && [_s_registerPhoneTF.text substringToIndex:1].intValue != 1) {
            [CddHud showTextOnly:@"请填写正确的注册电话" view:self.view];
            return NO;
        } else if (_s_bankTF.text.length < 1) {
            [CddHud showTextOnly:@"请填写开户银行" view:self.view];
            return NO;
        } else if (_s_bankAccountTF.text.length == 0) {
            [CddHud showTextOnly:@"请填写银行账户" view:self.view];
            return NO;
        } else if (_s_nickNameTF.text.length == 0) {
            [CddHud showTextOnly:@"请填写昵称" view:self.view];
            return NO;
        } else if (_s_addressTF.text.length == 0) {
            [CddHud showTextOnly:@"请填写地址" view:self.view];
            return NO;
        }
        return YES;
    }
    return YES;
}

//选择发票性质
- (void)selectType {
    [self.view endEditing:YES];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
    stringPickerView.title = @"请选择发票性质";
    stringPickerView.dataSourceArr = @[@"个人", @"企业"];
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        self.typeLab.text = resultModel.selectValue;
    };
    [stringPickerView show];
}

- (void)setScrol_1 {
    NSArray *titleArr = @[@"发票性质",@"发票抬头",@"发票内容",@"收票人手机号",@"是否默认"];
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        UIView *typeView = [[UIView alloc] init];
        typeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        typeView.backgroundColor = UIColor.whiteColor;
        [self.commonScrollView addSubview:typeView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = HEXColor(@"#4A4A4A", 1);
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.text = titleArr[i];
        [typeView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(typeView);
            make.height.mas_equalTo(20);
        }];
        
        if (i != 0) {
            typeView.top = 8 + (i * 50);
            [typeView addBorder:Line_Color width:0.5 direction:BorderDirectionBottom];
        }
        
        if (i == 0) {
            UIImageView *rightRow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
            [typeView addSubview:rightRow];
            [rightRow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(6);
                make.height.mas_equalTo(12);
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(typeView);
            }];
            
            _typeLab = [[UILabel alloc] init];
            _typeLab.font = [UIFont systemFontOfSize:14];
            _typeLab.textColor = HEXColor(@"#4A4A4A", 1);
            _typeLab.textAlignment = NSTextAlignmentRight;
            [typeView addSubview:_typeLab];
            [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(rightRow.mas_left).offset(-10);
                make.centerY.mas_equalTo(rightRow);
                make.height.mas_equalTo(120);
            }];
            [HelperTool addTapGesture:typeView withTarget:self andSEL:@selector(selectType)];
        }
        else if (i == 1 || i == 2 || i ==3) {
            UITextField *tf = [[UITextField alloc] init];
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = HEXColor(@"#4A4A4A", 1);
            tf.tintColor = HEXColor(@"#FF5100", 1);
            [typeView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KFit_W(120));
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(40);
                make.centerY.mas_equalTo(typeView);
            }];
            if (i == 1) {
                tf.placeholder = @"默认“个人”(可修改)";
                _titleTF = tf;
            } else if (i == 2) {
                tf.text = @"商品明细(不可修改)";
                tf.userInteractionEnabled = NO;
            } else if (i == 3) {
                tf.placeholder = @"请填写手机号";
                tf.keyboardType = UIKeyboardTypeNumberPad;
                tf.maxLength = 11;
                _phoneTF = tf;
                UIImageView *signImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark_icon"]];
                [typeView addSubview:signImg];
                [signImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(titleLab.mas_right).offset(2);
                    make.width.height.mas_equalTo(7);
                    make.centerY.mas_equalTo(titleLab.mas_centerY).offset(-2);
                }];
            }
        }
        else if (i == 4) {
            _defaultSwitch = [[UISwitch alloc] init];
            _defaultSwitch.onTintColor = HEXColor(@"#FF5100", 1);
            _defaultSwitch.thumbTintColor = UIColor.whiteColor;
            [typeView addSubview:_defaultSwitch];
            [_defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-20);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(24);
                make.centerY.mas_equalTo(typeView);
            }];
        }
    }
}

- (void)setScrol_2 {
    NSArray *titleArr = @[@"发票内容",@"单位名称",@"纳税人识别号码",@"注册地址",@"注册电话",@"开户银行",@"银行账户",@"昵称",@"地址",@"是否默认"];
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        UIView *typeView = [[UIView alloc] init];
        typeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        typeView.backgroundColor = UIColor.whiteColor;
        [self.vatScrollView addSubview:typeView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = HEXColor(@"#4A4A4A", 1);
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.text = titleArr[i];
        [typeView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(typeView);
            make.height.mas_equalTo(20);
        }];
        
        if (i != titleArr.count - 1) {
            UITextField *tf = [[UITextField alloc] init];
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = HEXColor(@"#4A4A4A", 1);
            tf.tintColor = HEXColor(@"#FF5100", 1);
            [typeView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KFit_W(130));
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(40);
                make.centerY.mas_equalTo(typeView);
            }];
            
            if (i == 0) {
                tf.userInteractionEnabled = NO;
                tf.text = @"商品明细(不可修改)";
                UILabel *lab = [[UILabel alloc] init];
                lab.text = @"公司信息";
                lab.textColor = HEXColor(@"#9B9B9B", 1);
                lab.font = [UIFont systemFontOfSize:14];
                lab.frame = CGRectMake(15, 50 + 22, 200, 20);
                lab.backgroundColor = UIColor.clearColor;
                [self.vatScrollView addSubview:lab];
            }
            else if (i == 1) {
                tf.placeholder = @"请填写单位名称";
                _s_nameTF = tf;
            }
            else if (i == 2) {
                tf.placeholder = @"请填写纳税人识别码";
                tf.keyboardType = UIKeyboardTypeNumberPad;
                _s_ratepayerTF = tf;
            }
            else if (i == 3) {
                tf.placeholder = @"请填写注册地址";
                _s_registerAddressTF = tf;
            }
            else if (i == 4) {
                tf.placeholder = @"请填写注册电话";
                tf.keyboardType = UIKeyboardTypeNumberPad;
                tf.maxLength = 11;
                _s_registerPhoneTF = tf;
            }
            else if (i == 5) {
                tf.placeholder = @"请填写开户银行";
                _s_bankTF = tf;
            }
            else if (i == 6) {
                tf.placeholder = @"请填写银行账户";
                _s_bankAccountTF = tf;
                UILabel *lab = [[UILabel alloc] init];
                lab.text = @"收票人信息";
                lab.textColor = HEXColor(@"#9B9B9B", 1);
                lab.font = [UIFont systemFontOfSize:14];
                lab.frame = CGRectMake(15, 50 * 9 + 22, 200, 20);
                lab.backgroundColor = UIColor.clearColor;
                [self.vatScrollView addSubview:lab];
            }
            else if (i == 7) {
                tf.placeholder = @"请填写昵称";
                _s_nickNameTF = tf;
            }
            else if (i == 8) {
                tf.placeholder = @"请填写地址";
                _s_addressTF = tf;
            }
        } else if (i == titleArr.count - 1) {
            _s_defaultSwitch = [[UISwitch alloc] init];
            _s_defaultSwitch.onTintColor = HEXColor(@"#FF5100", 1);
            _s_defaultSwitch.thumbTintColor = UIColor.whiteColor;
            [typeView addSubview:_s_defaultSwitch];
            [_s_defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-20);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(24);
                make.centerY.mas_equalTo(typeView);
            }];
        }
        //设置位置
        if (i != 0) {
            if (i <= 7) {
                typeView.top = 50 + i * 50;
            } else {
                typeView.top = 100 + i * 50;
            }
        }
        //加分割线
        if (i != 0 && i != titleArr.count - 1) {
            [typeView addBorder:Line_Color width:0.5 direction:BorderDirectionBottom];
        }
        //添加小星星
        if (i != 0 && i != 2) {
            UIImageView *signImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark_icon"]];
            [typeView addSubview:signImg];
            [signImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLab.mas_right).offset(2);
                make.width.height.mas_equalTo(7);
                make.centerY.mas_equalTo(titleLab.mas_centerY).offset(-2);
            }];
        }
    }
}

@end
