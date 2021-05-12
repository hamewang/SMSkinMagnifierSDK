//
//  DKSocket.h
//  DKWF
//
//  Created by nana on 2020/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMConfigDeviceSocket : NSObject
/// 给硬件设置可上网的Wi-Fi，没有密码的Wi-Fi 设置@“”
NSData *sm_sendSetWIFI(NSString *wifiname,NSString *pwd);
/// 硬件扫描周围Wi-Fi
NSData *sm_sendScanWIFI();
/// 获取当前配置的Wi-Fi信息
NSData *sm_sendGetWIFIInfo();
@property(nonatomic, copy)void(^checkNetWorkBlock)(BOOL networkStaus);
+ (instancetype)share;
/// 心跳的数据
@property(nonatomic,strong)NSData *heartbeatData;
/// 心跳的数据
@property(nonatomic, assign)BOOL connectStatus;
- (void)disconnect;
- (void)connectHost:(NSString *)host port:(uint16_t)port ;
- (void)sendData:(NSData *)data completeBlock:(void(^)(NSData *response))completeBlock;
@property(nonatomic, copy)void(^recvDataBlock)(NSData *rdata);
@end

NS_ASSUME_NONNULL_END
