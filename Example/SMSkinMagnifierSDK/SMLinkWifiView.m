//
//  SMLinkWifiView.m
//  SkinMagnifier
//
//  Created by nana on 2021/4/12.
//

#import "SMLinkWifiView.h"
#import "SMLinkSetOneView.h"
#import "SMLinkSetTwoView.h"
#import "SMLinkSetThreeView.h"
#import "SMConfigDeviceSocket.h"

#import "SMTool.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <NetworkExtension/NetworkExtension.h>

@interface SMLinkWifiView()

@property(nonatomic, weak)SMLinkSetOneView *oneView;
@property(nonatomic, weak)SMLinkSetTwoView *twoView;
@property(nonatomic, weak)SMLinkSetThreeView *threeView;
@property(nonatomic, weak)UILabel *tipsLabel;
@property(nonatomic, strong)SMConfigDeviceSocket *socket;
@property(nonatomic, strong)dispatch_source_t timer;
@end


@implementation SMLinkWifiView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.socket = [[SMConfigDeviceSocket alloc] init];
    [self.socket connectHost:@"192.168.168.1" port:8899];
    
    SMLinkSetOneView *oneView = [[SMLinkSetOneView alloc ] init];
    [self addSubview:oneView];
    _oneView = oneView;
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];


    SMLinkSetTwoView *twoView = [[SMLinkSetTwoView alloc ] init];
    @weakify(self);
    twoView.cancleBlock = ^{
        @strongify(self);
        self.flishBlock();
    };
    [self addSubview:twoView];
    _twoView = twoView;
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    SMLinkSetThreeView *threeView = [[SMLinkSetThreeView alloc ] init];
    [self addSubview:threeView];
    _threeView = threeView;
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.twoView.hidden = YES;
    self.threeView.hidden = YES;

    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = sm_RGBA(68, 57, 53, 1);
    [self addSubview:tipsLabel];
    _tipsLabel = tipsLabel;
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    

//    UIButton *cancleBtn = [[UIButton alloc] init];
//    [cancleBtn setImage:[UIImage imageNamed:@"pop_icon_Shut"] forState:UIControlStateNormal];
//    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:cancleBtn];
//    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(25);
//        make.left.mas_equalTo(5);
//        make.width.mas_equalTo(35);
//        make.height.mas_equalTo(35);
//    }];
    
    
    oneView.wifiStatusBlock = ^(BOOL linkStatus) {
        @strongify(self);
        self.oneView.hidden = linkStatus;
        self.twoView.hidden = !linkStatus;
        
        if (linkStatus) {
            if (!self.threeView.hidden) {
                self.tipsLabel.text = @"3/3";
            }else {
                self.tipsLabel.text = @"2/3";
            }
        }else {
            if (!self.oneView.hidden) {
                self.tipsLabel.text = @"1/3";
            }
        }
    };
    twoView.flishBlock = ^(NSString * _Nonnull account, NSString * _Nonnull pwd,void(^outBlock)(void)) {
        @strongify(self);
        /// 发送配网指令后， 设备会重启
        [self.socket sendData:sm_sendSetWIFI(account, pwd) completeBlock:^(NSData * _Nonnull response) {
            @strongify(self);
            if (!response) {
                [SVProgressHUD showErrorWithStatus:@"请求超时"];
                return ;
            }
            NSString *contString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"%@",contString);
            
            self.threeView.hidden = NO;
            self.twoView.hidden = YES;
            [self.threeView progressValue:30];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(29 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                outBlock();
                self.threeView.hidden = YES;
            });
        }];
    };

    twoView.moreWifiClick = ^(void (^ cBlock)(NSMutableArray *wifiArray)) {
        @strongify(self);
        [self.socket sendData:sm_sendScanWIFI() completeBlock:^(NSData * _Nonnull response) {

            if (!response) {
                cBlock(nil);
                return ;
            }
            NSString *contString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            NSRegularExpression *contregex = [NSRegularExpression regularExpressionWithPattern:@"<SSID>(.*?)</SSID>" options:NSRegularExpressionCaseInsensitive error:nil];
            NSMutableSet *wifiNameArray = [[NSMutableSet alloc] init];
            [contregex enumerateMatchesInString:contString options:kNilOptions range:NSMakeRange(0, contString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                
                NSString *xx = [contString substringWithRange:result.range];
                NSString *wifiName = [xx substringWithRange:NSMakeRange(6, xx.length-13)];
                [wifiNameArray addObject:wifiName];
            }];
            
            cBlock([wifiNameArray allObjects].mutableCopy);
            
        }];

    };
    
    dispatch_queue_t queue = dispatch_queue_create("com.idankee.linkwifi", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        @strongify(self);
        [self setTask];
    });
    dispatch_resume(timer);
    _timer = timer;

}

- (void)setTask {
    if ([sm_WIFIName() hasPrefix:@"DAS01"]) {
        [self.socket sendData:sm_sendGetWIFIInfo() completeBlock:^(NSData * _Nonnull response) {
            if (!response) {
                return;
            }
            
            NSString *contString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSRegularExpression *contregex = [NSRegularExpression regularExpressionWithPattern:@"<SSID>(.*?)</SSID>|<KEY>(.*?)</KEY>|<IP>(.*?)</IP>|<VERSION>(.*?)</VERSION>" options:NSRegularExpressionCaseInsensitive error:nil];
            NSMutableSet *wifiNameSet = [[NSMutableSet alloc] init];
            [contregex enumerateMatchesInString:contString options:kNilOptions range:NSMakeRange(0, contString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                [wifiNameSet addObject:result];
            }];
            NSArray *infoArray = [wifiNameSet allObjects];
            NSString *account = @"-";
            NSString *pwd = @"-";
            NSString *ip = @"-";
            NSString *version = @"-";
            for (NSTextCheckingResult *result in infoArray) {
                NSString *string = [contString substringWithRange:result.range];
                
                if ([string containsString:@"SSID"]) {
                    account = [string substringWithRange:NSMakeRange(6, string.length - 13)];
                }else if([string containsString:@"KEY"]) {
                    pwd = [string substringWithRange:NSMakeRange(5, string.length - 11)];
                }else if([string containsString:@"IP"]) {
                    ip = [string substringWithRange:NSMakeRange(4, string.length - 9)];
                }else if([string containsString:@"VERSION"]) {
                    version = [string substringWithRange:NSMakeRange(9, string.length - 19)];
                }
            }
            
            NSString *tipsString = [NSString stringWithFormat:@"固件版本:%@ 账号:%@ 密码:%@ IP:%@",version,account,pwd,ip];
 
            [self.twoView configDeviceTips:tipsString];

        }];
        
//        NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
//        pDict[@"mid"] = [SMGlobalModel share].mid;
//        @weakify(self);
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        [self postFormDataWithUrl:@"/magnifier/member/verifyMemberInfo" params:pDict showHUD:NO success:^(NSDictionary * _Nonnull responseObject, JFResponseModel * _Nonnull JsonData) {
//            @strongify(self);
//            if ([responseObject[@"code"]intValue ] == 200) {
//                if (self.flishBlock) {
//                    self.flishBlock();
//                }
//                dispatch_source_cancel(self.timer);
//                self.timer = nil;
//            }
//
//
//            dispatch_semaphore_signal(sema);
//        }];
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
}

- (void)cancleBtnClick:(UIButton *)btn {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}
@end
