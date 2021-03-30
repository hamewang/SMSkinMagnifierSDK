//
//  SMTakeImage.h
//  SMSkinMagnifierSDK_Example
//
//  Created by nana on 2021/3/15.
//  Copyright © 2021 wangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMTakeImageInputModel;
NS_ASSUME_NONNULL_BEGIN

@interface SMTakeImageView : UIView

///必填
@property(nonatomic, strong)SMTakeImageInputModel *inputModel;

/// 拍照回调takeStatus:YES 开始拍照,NO 结束拍照 .outputDict: cid:为顾客ID , cgid:顾客案例组ID.
@property(nonatomic, copy)void(^takeBlock)(BOOL takeStatus, NSDictionary *outputDict);
/// 拍照存储的数组
@property(nonatomic, strong)NSMutableArray *outputImageArray;
/// 输入传入参数
- (instancetype)initWithFrame:(CGRect)frame inputModel:(SMTakeImageInputModel *)inputModel;
@end

NS_ASSUME_NONNULL_END
