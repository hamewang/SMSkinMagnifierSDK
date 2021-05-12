//
//  SMLinkWifiView.h
//  SkinMagnifier
//
//  Created by nana on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLinkWifiView : UIView

@property(nonatomic, strong)void (^cancleBlock)(void);
@property(nonatomic, strong)void (^flishBlock)(void);
@end

NS_ASSUME_NONNULL_END
