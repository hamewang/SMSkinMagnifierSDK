//
//  SMTool.h
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/5/11.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


@interface SMTool : NSObject
NSString *sm_WIFIName(void);
UIColor *sm_RGBA(float r, float g, float b, float a);
NSAttributedString *sm_createAttString(NSString *str,CGFloat fontSize,UIColor *color);


@end


@interface UIView(SMTool)


/// 箭头显示在哪个位置 // 0 上,1下.2,左,3右
-(void)alertToView:(UIView *)pView Postion:(int)postion vsize:(CGSize)vsize;

/// 箭头消息在哪个位置 // 0 上,1下.2,左,3右
-(void)alertDisMiss;
@end
NS_ASSUME_NONNULL_END
