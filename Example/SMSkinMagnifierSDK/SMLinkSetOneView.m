//
//  SMLinkSetOneView.m
//  SkinMagnifier
//
//  Created by nana on 2021/4/12.
//

#import "SMLinkSetOneView.h"
#import <NetworkExtension/NetworkExtension.h>
#import <Masonry/Masonry.h>
#import "SMTool.h"
#import "MTQRScanView.h"
#import "UIView+SMShow.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SMLinkSetOneView()
@property(nonatomic, strong)dispatch_source_t timer;
@end


@implementation SMLinkSetOneView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *BigTipsLabel = [[UILabel alloc] init];
    BigTipsLabel.attributedText = sm_createAttString(@"第一步  连接设备", 25, sm_RGBA(76, 74, 66, 1));
    [self addSubview:BigTipsLabel];
    [BigTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(80);
    }];
    
    UILabel *tipsOneLabe = [[UILabel alloc] init];
    tipsOneLabe.attributedText = sm_createAttString(@"1.将设备开机，等待蓝色指示灯闪烁", 15, sm_RGBA(153, 153, 153, 1));
    [self addSubview:tipsOneLabe];
    [tipsOneLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(BigTipsLabel.mas_bottom).offset(30);
    }];
    
    UILabel *tipstwoLabe = [[UILabel alloc] init];
    tipstwoLabe.numberOfLines = 0;
    NSMutableAttributedString *twoAttString = [[NSMutableAttributedString alloc] initWithAttributedString:sm_createAttString(@"2.将手机连接到以“DAS”开头的\nWiFi网络，密码：12345678", 15, sm_RGBA(153, 153, 153, 1))];
    [twoAttString setAttributes:@{NSForegroundColorAttributeName:sm_RGBA(0, 0, 0, 1)} range:NSMakeRange(9, 5)];
    [twoAttString setAttributes:@{NSForegroundColorAttributeName:sm_RGBA(0, 0, 0, 1)} range:NSMakeRange(25, 11)];
    tipstwoLabe.attributedText = twoAttString;
    [self addSubview:tipstwoLabe];
    [tipstwoLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsOneLabe);
        make.top.equalTo(tipsOneLabe.mas_bottom).offset(20);
    }];
    
    UILabel *tipsthreeLabe = [[UILabel alloc] init];
    tipsthreeLabe.attributedText = sm_createAttString(@"3.返回APP", 15, sm_RGBA(153, 153, 153, 1));
    [self addSubview:tipsthreeLabe];
    [tipsthreeLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsOneLabe);
        make.top.equalTo(tipstwoLabe.mas_bottom).offset(20);
    }];
    
    
    UIImageView *tipsImageView = [[UIImageView alloc] init];
    tipsImageView.image = [UIImage imageNamed:@"link_tips_pop_bg"];
    [self addSubview:tipsImageView];
    [tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(tipsthreeLabe.mas_bottom).offset(25);
    }];
    
    
    UIButton *setBtn = [[UIButton alloc] init];
    [setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setAttributedTitle:sm_createAttString(@"前往设置", 15,sm_RGBA(255, 255, 255, 1)) forState:UIControlStateNormal];
    setBtn.layer.cornerRadius = 45/2.0;
    setBtn.backgroundColor = sm_RGBA(188, 171, 147, 1);
    
//    [setBtn setBackgroundImage:[[UIImage wb_imageWithColor:sm_RGBA(188, 171, 147, 1) size:CGSizeMake(225.5, 45)] sd_roundedCornerImageWithRadius:45/2.0 corners:0xff borderWidth:0 borderColor:sm_RGBA(0, 0, 0, 0)]  forState:UIControlStateNormal];
    [self addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(225.5, 45));
    }];
    
    UIButton *scanBtn = [[UIButton alloc] init];
    [scanBtn setImage:[UIImage imageNamed:@"scan_btn"] forState:UIControlStateNormal];
    [scanBtn setAttributedTitle:sm_createAttString(@"扫码连接", 15, sm_RGBA(255, 124, 78, 1)) forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo((-66));
        make.centerX.mas_equalTo(0);
    }];

    __weak typeof(self) weakSelf = self;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{

        [weakSelf setTask];
    });
    dispatch_resume(timer);
    _timer = timer;
    
}



- (void)scanBtnClick:(UIButton *)btn {
    MTQRScanView *scanView = [[MTQRScanView alloc] init];
    scanView.bounds = self.bounds;
    [scanView show];
    @weakify(scanView);
    scanView.QRResultBlock = ^(NSString * _Nonnull QRstring) {
        @strongify(scanView);
        NSString *wifiName = @"";
        if (QRstring.length >6) {
            wifiName = [NSString stringWithFormat:@"DAS01-1_%@",[QRstring substringFromIndex:QRstring.length-6]];
        }else {
            wifiName = [NSString stringWithFormat:@"DAS01-1_%@",QRstring];
        }

        [SVProgressHUD show];
        NEHotspotConfiguration *hotspotConfig = [[NEHotspotConfiguration alloc]initWithSSID:wifiName passphrase:@"12345678" isWEP:NO];
        hotspotConfig.joinOnce = NO;
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if ([sm_WIFIName() hasPrefix:@"DAS01"]) {
                    [SVProgressHUD showSuccessWithStatus:@"加入Wi-Fi成功"];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"加入Wi-Fi失败"];
                }
            });
        }];

    };
}

- (void)setTask {
    
   
    if (self.wifiStatusBlock) {
        self.wifiStatusBlock([sm_WIFIName() hasPrefix:@"DAS01"]);
    }
}

- (void)setBtnClick:(UIButton *)btn {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}
@end
