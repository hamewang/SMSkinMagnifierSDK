//
//  SMLinkSetTwoView.m
//  SkinMagnifier
//
//  Created by nana on 2021/4/12.
//

#import "SMLinkSetTwoView.h"
#import "JFDCWIFIListCell.h"
#import "SMTool.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SMLinkSetTwoView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, weak)UITextField *accountTF;
@property(nonatomic, weak)UITextField *pwdTF;
@property(nonatomic, weak)UIButton *noWifiBtn;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, weak)UILabel *wifiLabel;
@end

@implementation SMLinkSetTwoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    UILabel *BigTipsLabel = [[UILabel alloc] init];
    BigTipsLabel.attributedText = sm_createAttString(@"第二步  设备配网", 25, sm_RGBA(76, 74, 66, 1));
    [self addSubview:BigTipsLabel];
    [BigTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo((80));
    }];
    
    UILabel *tipsOneLabe = [[UILabel alloc] init];
    tipsOneLabe.attributedText = sm_createAttString(@"请选择可用Wi-Fi，供设备上网", 15, sm_RGBA(153, 153, 153, 1));
    [self addSubview:tipsOneLabe];
    [tipsOneLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(BigTipsLabel.mas_bottom).offset(30);
    }];
    
    UILabel *tipsTwolabel = [[UILabel alloc] init];
    tipsTwolabel.attributedText = sm_createAttString(@"*如无可用WiFi，请下拉刷新", 12, sm_RGBA(255, 124, 82, 1));
    [self addSubview:tipsTwolabel];
    [tipsTwolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(tipsOneLabe.mas_bottom).offset(11);
    }];
    
    UILabel *wifiLabel = [[UILabel alloc] init];
    [self addSubview:wifiLabel];
    _wifiLabel = wifiLabel;
    [wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(tipsTwolabel.mas_bottom).offset(11);
    }];
    
    
    UITextField *accountTF = [[UITextField alloc] init];
    accountTF.attributedPlaceholder = sm_createAttString(@"请选择账号", 15, sm_RGBA(68, 57, 53, 1));
    [self addSubview:accountTF];
    _accountTF = accountTF;
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(tipsTwolabel.mas_bottom).offset(64);
        make.height.mas_equalTo(35);
    }];
    UIView *lineAccountView = [[UIView alloc] init];
    lineAccountView.backgroundColor = sm_RGBA(229, 229, 229, 1);
    [self addSubview:lineAccountView];
    [lineAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(accountTF);
        make.top.equalTo(accountTF.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn setImage:[UIImage imageNamed:@"customer_icon_xyb"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(accountTF).offset(15);
        make.centerY.equalTo(accountTF);
        make.size.mas_equalTo(CGSizeMake(33 , 33));
    }];
    
    UITextField *pwdTF = [[UITextField alloc] init];
    pwdTF.attributedPlaceholder = sm_createAttString(@"请输入密码", 15, sm_RGBA(68, 57, 53, 1));
    [self addSubview:pwdTF];
    _pwdTF = pwdTF;
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(accountTF.mas_bottom).offset(30);
        make.height.mas_equalTo(35);
    }];
    UIView *linePwdView = [[UIView alloc] init];
    linePwdView.backgroundColor = sm_RGBA(229, 229, 229, 1);
    [self addSubview:linePwdView];
    [linePwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(pwdTF);
        make.top.equalTo(pwdTF.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UIButton *saveWifiBtn = [[UIButton alloc] init];
    [saveWifiBtn setAttributedTitle:sm_createAttString(@"保存有效账号密码", 12, sm_RGBA(153, 153, 153, 1)) forState:UIControlStateNormal];
    [saveWifiBtn addTarget:self action:@selector(saveWifiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveWifiBtn setImage:[UIImage imageNamed:@"report_icon_check_nor"] forState:UIControlStateNormal];
    [saveWifiBtn setImage:[UIImage imageNamed:@"report_icon_check_sel"] forState:UIControlStateSelected];
    [self addSubview:saveWifiBtn];
    [saveWifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdTF);
        make.top.equalTo(pwdTF.mas_bottom).offset(15);
    }];
    
    UIButton *noWifiBtn = [[UIButton alloc] init];
    [noWifiBtn addTarget:self action:@selector(noWifiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [noWifiBtn setAttributedTitle:sm_createAttString(@"WiFi未设置密码", 12, sm_RGBA(153, 153, 153, 1)) forState:UIControlStateNormal];
    
    [noWifiBtn setImage:[UIImage imageNamed:@"report_icon_check_nor"] forState:UIControlStateNormal];
    [noWifiBtn setImage:[UIImage imageNamed:@"report_icon_check_sel"] forState:UIControlStateSelected];
    [self addSubview:noWifiBtn];
    _noWifiBtn =noWifiBtn;
    [noWifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pwdTF);
        make.top.equalTo(pwdTF.mas_bottom).offset(15);
    }];
    
    UIButton *setBtn = [[UIButton alloc] init];
    [setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setAttributedTitle:sm_createAttString(@"验证WiFi是否可用", 15,sm_RGBA(255, 255, 255, 1)) forState:UIControlStateNormal];
    setBtn.backgroundColor = sm_RGBA(188, 171, 147, 1);
    setBtn.layer.cornerRadius  = 45/2.0;
//    [setBtn setBackgroundImage:[[UIImage wb_imageWithColor:sm_RGBA(188, 171, 147, 1) size:CGSizeMake(225.5, 45)] sd_roundedCornerImageWithRadius:45/2.0 corners:0xff borderWidth:0 borderColor:sm_RGBA(0, 0, 0, 0)]  forState:UIControlStateNormal];
    [self addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(225.5, 45));
    }];
    
    UIButton *cancleBtn = [[UIButton alloc] init];
    [cancleBtn setAttributedTitle:sm_createAttString(@"退出连接", 15, sm_RGBA(255, 124, 78, 1)) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-66);
        make.centerX.mas_equalTo(0);
    }];
    
    NSDictionary *sdict = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveWifiKey"];
    if (sdict) {
        saveWifiBtn.selected = YES;
        self.accountTF.text = sdict[@"account"];
        self.pwdTF.text = sdict[@"pwd"];
        if (self.pwdTF.text.length) {
            noWifiBtn.selected = NO;
        }else {
            noWifiBtn.selected = YES;
        }
    }
    
}

- (void)cancleBtnClick:(UIButton *)btn {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}
- (void)noWifiBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.pwdTF.hidden = btn.selected;
}

- (void)saveWifiBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
}
- (void)setBtnClick:(UIButton *)btn {
    NSString *pwd = self.pwdTF.text;
    if (self.noWifiBtn.selected) {
        pwd = @"";
    }
    if (self.flishBlock) {
        self.flishBlock(self.accountTF.text, pwd, ^{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict[@"account"] = self.accountTF.text;
            dict[@"pwd"] = pwd;
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"saveWifiKey"];
        });
    }
}

- (void)moreBtnClick:(UIButton *)btn {
    @weakify(self);
    [SVProgressHUD show];
    self.moreWifiClick(^(NSMutableArray *wifiArray) {
        @strongify(self);
        [SVProgressHUD dismiss];
        if (!wifiArray) {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            return;
        }
 
        if (!wifiArray.count) {
            [SVProgressHUD showErrorWithStatus:@"wifi列表获取失败"];
            return;
        }
        self.dataArray = wifiArray;
        UIView *showView = [[UIView alloc] init];
        showView.backgroundColor = [UIColor whiteColor];
        showView.layer.cornerRadius = 5;
        showView.layer.masksToBounds = YES;
        [showView alertToView:btn Postion:3 vsize:CGSizeMake(224, 186)];
        
        UITableView *tbView = [[UITableView alloc] init];

        tbView.frame = CGRectMake(0, 0, 224, 186);
        tbView.dataSource  = self;
        tbView.delegate = self;
        tbView.tableFooterView = [UIView new];
        [tbView registerClass:[JFDCWIFIListCell class] forCellReuseIdentifier:NSStringFromClass([JFDCWIFIListCell class])];
        [showView  addSubview:tbView];
        
    });

}


- (void)configDeviceTips:(NSString *)tips {
    self.wifiLabel.attributedText = sm_createAttString(tips, 12, sm_RGBA(255, 124, 82, 1));
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFDCWIFIListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JFDCWIFIListCell class])];
    cell.SSIDLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.accountTF.text = self.dataArray[indexPath.row];
    [tableView.superview.superview removeFromSuperview];
}

@end
