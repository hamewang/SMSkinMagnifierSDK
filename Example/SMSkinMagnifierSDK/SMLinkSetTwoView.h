//
//  SMLinkSetTwoView.h
//  SkinMagnifier
//
//  Created by nana on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLinkSetTwoView : UIView
@property(nonatomic, copy)void (^flishBlock)(NSString *account ,NSString *pwd, void(^outBlock)(void));
@property(nonatomic, copy)void(^moreWifiClick)(void(^inBlock)(NSMutableArray *wifiArray));

@property(nonatomic, copy)void (^cancleBlock)(void);

- (void)configDeviceTips:(NSString *)tips;
@end

NS_ASSUME_NONNULL_END
