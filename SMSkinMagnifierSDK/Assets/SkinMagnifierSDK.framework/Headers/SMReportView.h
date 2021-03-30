//
//  SMReportView.h
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/3/15.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMReportInputModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SMReportView : UIView

/// 输入传入参数
- (instancetype)initWithFrame:(CGRect)frame inputModel:(SMReportInputModel *)inputModel;
@end

NS_ASSUME_NONNULL_END
