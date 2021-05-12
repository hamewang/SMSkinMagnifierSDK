//
//  MTQRScanView.h
//  Metis
//
//  Created by wb on 2019/9/26.
//  Copyright © 2019 曾凌坤. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTQRScanView : UIView

@property(nonatomic, strong)void (^QRResultBlock)(NSString *QRstring);

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
