//
//  UIView+SMShow.h
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/3/29.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SMShow)
/// 中间放大
- (void)sm_showlTBFromSuperView:(UIView *)view;
- (void)sm_disBTlLMiss;
@end

NS_ASSUME_NONNULL_END
