//
//  SMViewController.m
//  SMSkinMagnifierSDK
//
//  Created by wangbiao on 03/08/2021.
//  Copyright (c) 2021 wangbiao. All rights reserved.
//

#import "SMViewController.h"
#import "UIView+SMShow.h"

//#import "SMSkinMagnifierSDKConfig.h"
//#import "SMTakeImageInputModel.h"
//#import "SMTakeImageView.h"
//#import "SMReportInputModel.h"
//#import "SMReportView.h"

#import <SkinMagnifierSDK/SMSkinMagnifierSDKConfig.h>
#import <SkinMagnifierSDK/SMTakeImageInputModel.h>
#import <SkinMagnifierSDK/SMTakeImageView.h>
#import <SkinMagnifierSDK/SMReportInputModel.h>
#import <SkinMagnifierSDK/SMReportView.h>

@interface SMViewController ()

@property(nonatomic, strong)NSString *cid;

@property(nonatomic, strong)NSString *cgid;
@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [[SMSkinMagnifierSDKConfig share] setupSDKWithMid:@"9076" token:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjA3NzIyOTcsImp0aSI6IjkwNzYifQ.W8QhcO3u3uncbcPlBfLCH_y4nUXHyWTwslKr9KMX-tI"];
    
    UIButton *createUserBtn  = [[UIButton alloc] init];
    [createUserBtn setTitle:@"创建顾客" forState:UIControlStateNormal];
    createUserBtn.backgroundColor = [UIColor redColor];
    createUserBtn.frame = CGRectMake(50, 100, 100, 50);
    [createUserBtn addTarget:self action:@selector(createUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createUserBtn];
    
    UIButton *reportBtn  = [[UIButton alloc] init];
    [reportBtn setTitle:@"报告数据" forState:UIControlStateNormal];
    reportBtn.backgroundColor = [UIColor redColor];
    reportBtn.frame = CGRectMake(200, 100, 100, 50);
    [reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportBtn];

    UIButton  *btn = [[UIButton alloc] init];
    [btn setTitle:@"照片" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(50, 200, 50, 50);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton  *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"报告" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    btn1.frame = CGRectMake(200, 200, 50, 50);
    [btn1 addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    self.cid = @"1298952";
    self.cgid = @"554EE6D03DE144DEB69320ABB18E7DFD";

}

- (void)reportBtnClick:(UIButton *)btn {
    [[SMSkinMagnifierSDKConfig share] requestReportWithcid:self.cid cgid:self.cgid success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
    }];
}
- (void)createUserBtnClick:(UIButton *)btn {
    [[SMSkinMagnifierSDKConfig share] createUserWithUserName:@"xxx" success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            self.cid = ((NSDictionary *)responseObject[@"data"])[@"cid"];
        }
 
    }];
}
/*
 
 

 (lldb) po self.cgid
 
 **/

- (void)btnClick1:(UIButton *)btn {
    SMReportInputModel *inputModel = [[SMReportInputModel alloc] init];
    inputModel.cid =  self.cid;
    inputModel.cgid = self.cgid;
    
    SMReportView *tView = [[SMReportView alloc] initWithFrame:self.view.bounds inputModel:inputModel];

    [tView sm_showlTBFromSuperView:self.view];
    
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(100, 100, 50, 50);
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tView addSubview:backBtn];
    
}

- (void)btnClick:(UIButton *)btn
{
    SMTakeImageInputModel *inputModel = [[SMTakeImageInputModel alloc] init];
    inputModel.cid = self.cid;
    inputModel.spread = @"xxxx";
    
    SMTakeImageView *tView = [[SMTakeImageView alloc] initWithFrame:self.view.bounds inputModel:inputModel];
    [tView sm_showlTBFromSuperView:self.view];
    tView.takeBlock = ^(BOOL takeStatus, NSDictionary * _Nonnull outputDict) {
        self.cgid = outputDict[@"cgid"];
        NSLog(@"%@",outputDict);
    };
    
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(100, 100, 50, 50);
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tView addSubview:backBtn];

}

- (void)backBtnClick:(UIButton *)btn {
    [btn.superview sm_disBTlLMiss];
}
@end
