//
//  MTQRScanView.m
//  Metis
//
//  Created by wb on 2019/9/26.
//  Copyright © 2019 曾凌坤. All rights reserved.
//

#import "MTQRScanView.h"

#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import "SMTool.h"

@interface MTQRScanView()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;



@end

@implementation MTQRScanView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self startScan];
    }
    return self;
}

- (void)setupUI {

    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"scan_tips_bg"];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
//
    self.backgroundColor = [UIColor whiteColor];
    
    
//    UIButton *backBtn  = [[UIButton alloc] init];
//    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
////    [backBtn setBackgroundImage:[UIImage imageNamed:@"MoremeSDKBundle.bundle/login_return"] forState:UIControlStateNormal];
////    [backBtn setTitle:kMultiLangString(@"关闭")  textColor:rgba(255, 255, 255, 1) font:kFontSize(13) forState:UIControlStateNormal];
//
//
//    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:backBtn];
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
//        make.top.mas_equalTo(20);
////        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(30);
//    }];
    
    UIButton *cancleBtn = [[UIButton alloc] init];
    [cancleBtn setImage:[UIImage imageNamed:@"pop_icon_Shut"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    
    UIButton *titleBtn = [[UIButton alloc]init];
    [titleBtn setAttributedTitle:sm_createAttString(( @"请扫描设备二维码"), 15, sm_RGBA(255, 255, 255, 1)) forState:UIControlStateNormal];
    titleBtn.contentEdgeInsets =UIEdgeInsetsMake(6, 20, 6, 20);
    titleBtn.backgroundColor = sm_RGBA(0, 0, 0, 0.33);

    titleBtn.layer.cornerRadius = 5;
    [self addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo((66));
    
    }];

}

- (BOOL)startScan {

    // 获取手机硬件设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@",[error localizedDescription]);
        return NO;
    }
    
    
      if (![captureDevice lockForConfiguration:nil]) {
         
       }
       
//       [captureDevice setExposureTargetBias:0.5 completionHandler:^(CMTime syncTime) {
//             
//        }];
    
       [captureDevice unlockForConfiguration];
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 创建摄像数据输出流并将其添加到会话对象上,  --> 用于识别光线强弱
       self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
       [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
       [_captureSession addOutput:_videoDataOutput];
    // 添加输出流
    [_captureSession addOutput:output];
    // 创建dispatch queue
    dispatch_queue_t queue = dispatch_queue_create("com.mtesi.scan", DISPATCH_QUEUE_CONCURRENT);
    //扫描的结果苹果是通过代理的方式区回调，所以outPut需要添加代理，并且因为扫描是耗时的工作，所以把它放到子线程里面
    [output setMetadataObjectsDelegate:self queue:queue];
    // 设置支持二维码和条形码扫描
  //  [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    // 7、设置数据输出类型(如下设置为条形码和二维码兼容)，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    // 创建输出对象
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        @strongify(self);//(origin = (x = 234, y = 362), size = (width = 300, height = 300))
        CGSize scanSize = CGSizeMake(230, 230);
        
        output.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect: CGRectMake( (self.frame.size.width-230)/2,(self.frame.size.height-230)/2, 230, 230)];
    }];
    
    // 开始会话
    [_captureSession startRunning];
    return YES;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _previewLayer.frame = self.bounds;
    [self.layer insertSublayer:_previewLayer atIndex:0];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
// 扫描结果的代理回调方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && metadataObjects.count > 0) {
        // 获取结果并对其进行处理
        AVMetadataMachineReadableCodeObject *object = metadataObjects.firstObject;
        if ([[object type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *result = object.stringValue;
            // 处理result
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",result);
                if (self.QRResultBlock) {
                    self.QRResultBlock(result);
                    self.QRResultBlock = nil;
                }
                [self dismiss];
            });
        } else {
        }
    }
}

//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"metadataObjects - - %@", metadataObjects);
//    if (metadataObjects != nil && metadataObjects.count > 0) {
//        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        NSLog(@"%@",[obj stringValue]);
//        if (self.delegate && [self.delegate respondsToSelector:@selector(scanResult:)]) {
//            [self.delegate scanResult:[obj stringValue]];
//            [_session stopRunning];
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    } else {
//        NSLog(@"暂未识别出扫描的二维码");
//    }
//}

- (void)show
{
    UIWindow *wind = [UIApplication sharedApplication].windows.lastObject; 
    [wind addSubview:self];
    self.frame = CGRectMake(0, wind.frame.size.height, wind.frame.size.width, wind.frame.size.height);

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = wind.bounds;
    }];
    
}
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect R = self.frame;
        
//        self.y = R.size.height;
        self.frame = CGRectMake(R.origin.x, R.size.height, R.size.width, R.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
