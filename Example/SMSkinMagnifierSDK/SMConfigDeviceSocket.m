//
//  DKSocket.m
//  DKWF
//
//  Created by nana on 2020/7/1.
//

#import "SMConfigDeviceSocket.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>


@interface SMConfigDeviceSocket()<GCDAsyncSocketDelegate>
@property(nonatomic, strong)GCDAsyncSocket *tcpSocket;
@property(atomic, strong)NSLock *lock;
@property(nonatomic, strong)dispatch_queue_t sendMessageQueue;
@property(nonatomic, strong)dispatch_queue_t connectQueue;
@property(nonatomic, assign)NSTimeInterval lastReceiveImageTime;
@property(nonatomic, strong)dispatch_source_t gcdTimer;
@property(nonatomic, strong)NSString *host;
@property(nonatomic, assign)int port;

@property(atomic, strong)void(^completeBlock)(NSData *response);
@property(nonatomic, strong)NSMutableData *recvData;
@property(nonatomic, assign)BOOL noConnect;
/// 第2次
@property(nonatomic, assign)BOOL doubleSend;
@end

@implementation SMConfigDeviceSocket
NSData *sm_sendSetWIFI(NSString *wifiname,NSString *pwd) {
    NSString *cmdString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><CMD_REQ code=2 index=2><SSID>%@</SSID><PASSWORD>%@</PASSWORD></CMD_REQ>",wifiname,pwd];
    return [cmdString dataUsingEncoding:NSUTF8StringEncoding];
}
NSData *sm_sendScanWIFI() {
    return [@"<?xml version=\"1.0\" encoding=\"utf-8\"?><CMD_REQ code=1 index=1/>" dataUsingEncoding:NSUTF8StringEncoding];
}
NSData *sm_sendGetWIFIInfo() {
    return [@"<?xml version=\"1.0\" encoding=\"utf-8\"?><CMD_REQ code=3 index=3/>" dataUsingEncoding:NSUTF8StringEncoding];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

static SMConfigDeviceSocket *info = nil;
static dispatch_once_t onceToken;
+(instancetype)share
{
    dispatch_once(&onceToken, ^{
        if (info==nil) {
            info = [[SMConfigDeviceSocket alloc] init] ;
        }
    });
    return info ;
}


- (void)setup {
    self.noConnect = YES;
    _recvData = [NSMutableData data];
    _lock =[[NSLock alloc] init];
    _sendMessageQueue = dispatch_queue_create("SM.SendMessage", DISPATCH_QUEUE_SERIAL);
    _connectQueue = dispatch_queue_create("SM.TCPconnect", DISPATCH_QUEUE_SERIAL);
    self.tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_connectQueue];
    
    __weak typeof(self) weakSelf = self;
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        [weakSelf autoCheck];
    });

    dispatch_resume(_gcdTimer);
}

- (void)autoCheck {
    if ( self.noConnect) {
        return ;
    }
    
    if (self.connectStatus == NO) {
        [self connectHost:self.host port:self.port];
    }else {
        if (self.heartbeatData) {
            self.doubleSend = !self.doubleSend;
            if (self.doubleSend) {
                [self sendData:self.heartbeatData completeBlock:^(NSData * _Nonnull response) {
                }];
            }
        }
    }
}
- (void)disconnect {
    self.noConnect = YES;
    self.connectStatus = NO;
    [self.tcpSocket setDelegate:nil delegateQueue:NULL];
    [self.tcpSocket disconnect];
}

- (void)connectHost:(NSString *)host port:(uint16_t)port {

    
    self.noConnect = NO;
    self.host = host;
    self.port = port;
    [self.tcpSocket setDelegate:nil delegateQueue:NULL];
    [self.tcpSocket disconnect];
    [self.tcpSocket setDelegate:self delegateQueue:_connectQueue];
    [self.tcpSocket connectToHost:host onPort:port withTimeout:2 error:nil];
}


- (void)sendData:(NSData *)data completeBlock:(void(^)(NSData *response))completeBlock {
    if (self.connectStatus == NO || !data) {
        if (completeBlock) {
            completeBlock(nil);
        }
        return ;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(_sendMessageQueue, ^{
        [weakSelf.lock lock];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(xxx) withObject:nil afterDelay:2];
        });
        weakSelf.completeBlock = completeBlock;
        if (data) {
            [weakSelf.tcpSocket writeData:data withTimeout:2 tag:0];
        }
    });
}

- (void)xxx {
    if (self.completeBlock) {
        self.completeBlock(nil);
        self.completeBlock = nil;
        [self.lock unlock];
    }
}

-(void)dealloc {
    [self.tcpSocket setDelegate:nil delegateQueue:NULL];
    [self.tcpSocket disconnect];
    
}




//已经连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(nonnull NSString *)host port:(uint16_t)port{
//    NSLog(@"连接成功 : %@---%d",host,port);
    self.connectStatus = YES;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.checkNetWorkBlock) {
            weakSelf.checkNetWorkBlock(YES);
        }
    });
    [sock readDataWithTimeout:-1 tag:10086];
}

// 连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
//    NSLog(@"断开 %d socket连接 原因:%@",self.port, err);
    self.connectStatus = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.checkNetWorkBlock) {
            weakSelf.checkNetWorkBlock(NO);
        }
    });
}


//已经接收服务器返回来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
//    NSLog(@"%d %ld",sock.connectedPort,data.length);
//        NSLog(@"%d %@",sock.connectedPort,data);
    __weak typeof(self) weakSelf = self;
    dispatch_async(_sendMessageQueue, ^{
        
//        NSLog(@"%d %ld",sock.connectedPort , data.length);
        [weakSelf.recvData appendData:data];
        if (weakSelf.recvData.length<10) {
            [sock readDataWithTimeout:-1 tag:10086];
            return ;
        }
        
        NSData *rData = [NSData dataWithData:weakSelf.recvData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.completeBlock) {
                         
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(xxx) object:nil];
                weakSelf.completeBlock(rData);
                weakSelf.completeBlock = nil;
                [weakSelf.lock unlock];
            }
            if (weakSelf.recvDataBlock) {
                weakSelf.recvDataBlock(rData);
            }
        });
        weakSelf.recvData = [NSMutableData data];
        [sock readDataWithTimeout:-1 tag:10086];
    });
    
    
}



@end
