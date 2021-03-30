//
//  UIView+SMShow.m
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/3/29.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import "UIView+SMShow.h"

@implementation UIView (SMShow)


- (void)sm_showlTBFromSuperView:(UIView *)view {
    UIButton *wb_backView = [[UIButton alloc] init];
    [wb_backView addTarget:self action:@selector(wb_disBTlLMiss) forControlEvents:UIControlEventTouchUpInside];
    wb_backView.frame =[UIScreen mainScreen].bounds;
    wb_backView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [wb_backView addSubview:self];
    self.center = wb_backView.center;
    [view addSubview:wb_backView];
    [self animationWithLayer:wb_backView.layer duration:0.25 values:@[@0.0, @1.2, @1.0]];
}

- (void)sm_disBTlLMiss
{
    UIView *wb_backView = self.superview;
    [self animationWithLayer:wb_backView.layer duration:0.25 values:@[@1.0, @0.66, @0.33, @0.0]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wb_backView removeFromSuperview];
    });
}

- (void)animationWithLayer:(CALayer *)layer duration:(CGFloat)duration values:(NSArray *)values
{
    CAKeyframeAnimation *KFAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    KFAnimation.duration = duration;
    KFAnimation.removedOnCompletion = NO;
    KFAnimation.fillMode = kCAFillModeForwards;

    NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:values.count];
    for (NSUInteger i = 0; i<values.count; i++) {
        CGFloat scaleValue = [values[i] floatValue];
        [valueArr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(scaleValue, scaleValue, scaleValue)]];
    }
    KFAnimation.values = valueArr;
    KFAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

    [layer addAnimation:KFAnimation forKey:nil];
}


@end
