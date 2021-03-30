//
//  SMSMSkinMagnifierSDKConfig.h
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/3/22.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSkinMagnifierSDKConfig : NSObject
+ (instancetype)share;
- (void)setupSDKWithMid:(NSString *)mid token:(NSString *)token;

/// 根据用户名字创建，code:201 代表创建失败
- (void)createUserWithUserName:(NSString *)userName success:(void (^)(NSDictionary *responseObject))success;
@end

NS_ASSUME_NONNULL_END
