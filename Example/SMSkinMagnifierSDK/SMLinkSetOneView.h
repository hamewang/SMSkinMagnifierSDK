//
//  SMLinkSetOneView.h
//  SkinMagnifier
//
//  Created by nana on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLinkSetOneView : UIView
@property(nonatomic, copy)void (^wifiStatusBlock)(BOOL linkStatus);
@end

NS_ASSUME_NONNULL_END
