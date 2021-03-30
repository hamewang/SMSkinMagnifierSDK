//
//  SMReportInputModel.h
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/3/15.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMReportInputModel : NSObject
/// 顾客iD: 必填
@property(nonatomic, strong)NSString *cid;
/// 顾客案例组iD: 必填
@property(nonatomic, strong)NSString *cgid;
@end

NS_ASSUME_NONNULL_END
