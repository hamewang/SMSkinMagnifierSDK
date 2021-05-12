//
//  SMTool.m
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/5/11.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import "SMTool.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation SMTool

NSString *sm_WIFIName(void)
{
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
     for (NSString *ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) ifname);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    NSString *ssid = [dic objectForKey:@"SSID"];
    return ssid;
}

UIColor *sm_RGBA(float r, float g, float b, float a) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

NSAttributedString *sm_createAttString(NSString *str,CGFloat fontSize,UIColor *color) {

    
    if (!str || ![str isKindOfClass:[NSString class]]) {
        str = @"";
    }
    NSMutableDictionary *pDict = [[NSMutableDictionary alloc] init];
    pDict[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    pDict[NSForegroundColorAttributeName] = color;
    
    return [[NSAttributedString alloc ] initWithString:str attributes:pDict];
    
}


@end

@implementation UIView (SMTool)


/// 箭头显示在哪个位置
-(void)alertToView:(UIView *)pView Postion:(int)postion vsize:(CGSize)vsize{
    UIResponder *nextResponder =  pView;
    UIViewController *vc = nil;
    do
    {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            vc = (UIViewController*)nextResponder;
            
        }

    } while (nextResponder);
    
    UIControl *bgView = [[UIControl alloc] init];
    bgView.tag = 147889;
    [bgView addTarget:bgView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    bgView.backgroundColor = sm_RGBA(0, 0, 0, 0.3);
    bgView.frame = CGRectMake(0, 0, vc.view.frame.size.width,  vc.view.frame.size.height);
    [vc.view addSubview:bgView];
    
    CGRect xRect = [pView.superview convertRect:pView.frame toView:vc.view];
    UIImageView *jtImageView = [[UIImageView alloc] init];
    jtImageView.image = [UIImage  imageNamed:@"alert_pop_tk"];
    [bgView addSubview:jtImageView];

    [bgView addSubview:self];
    
    /// 下面
    jtImageView.frame = CGRectMake(xRect.origin.x,  CGRectGetMaxY(xRect), 18, 14);
    CGFloat vX = xRect.origin.x - (vsize.width/2.0);
    if (vX +vsize.width > bgView.frame.size.width) { // 右边
        CGFloat d = (vX + vsize.width) - bgView.frame.size.width;
        vX =vX - d - 10;
    }
    // 左边为做
    self.frame = CGRectMake(vX, CGRectGetMaxY(xRect)+10, vsize.width, vsize.height);

}

-(void)alertDisMiss {
    UIResponder *nextResponder =  self;
    UIViewController *vc = nil;
    do
    {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            vc = (UIViewController*)nextResponder;
            
        }

    } while (nextResponder);
    
    for (UIView *vView in  vc.view.subviews) {
        if (vView.tag == 147889) {
            [vView removeFromSuperview];
            break;;
        }
    }
    
}

@end
