# MMTakeImage

[![CI Status](https://img.shields.io/travis/304635659@qq.com/MMTakeImage.svg?style=flat)](https://travis-ci.org/304635659@qq.com/MMTakeImage)
[![Version](https://img.shields.io/cocoapods/v/MMTakeImage.svg?style=flat)](https://cocoapods.org/pods/MMTakeImage)
[![License](https://img.shields.io/cocoapods/l/MMTakeImage.svg?style=flat)](https://cocoapods.org/pods/MMTakeImage)
[![Platform](https://img.shields.io/cocoapods/p/MMTakeImage.svg?style=flat)](https://cocoapods.org/pods/MMTakeImage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MMTakeImage is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MMTakeImage', :git => 'https://github.com/hamewang/SMSkinMagnifierSDK.git',:branch => 'master'
```
## Usage
 Xcode工程添加获取Wi-Fi信息授权
 Xcode 添加获取地理位置授权, 必须打开定位使用
环境初始化
```objective-c
[[SMSkinMagnifierSDKConfig share] setupSDKWithMid:@"1480"token:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MTczNzE3NjAsImp0aSI6IjE0ODAifQ.NoSBQ3ejFj8gPZdDeyKGTbSyesSVLta4U34Qx_vgPkI"];
```
创建顾客
```objective-c
[[SMSkinMagnifierSDKConfig share] createUserWithUserName:@"xxx" success:^(NSDictionary * _Nonnull responseObject) {
    if ([responseObject[@"code"] intValue] == 200) {
        NSString *cid = ((NSDictionary *)responseObject[@"data"])[@"cid"];
    }

}];

```

拍照： 根据cid创建顾客案例组，返回cgid 《切勿乱传。一定要用创建顾客返回的ID。否则数据找不到》
```objective-c
SMTakeImageInputModel *inputModel = [[SMTakeImageInputModel alloc] init];
inputModel.cid = self.cid;
inputModel.spread = @"xxxx"; //第三方透传字段

SMTakeImageView *tView = [[SMTakeImageView alloc] initWithFrame:self.view.bounds inputModel:inputModel];
[tView sm_showlTBFromSuperView:self.view];
tView.takeBlock = ^(BOOL takeStatus, NSDictionary * _Nonnull outputDict) {
    self.cgid = outputDict[@"cgid"];
    NSLog(@"%@",outputDict);
};

```
查看报告参数cid, cgid 
```objective-c
SMReportInputModel *inputModel = [[SMReportInputModel alloc] init];
inputModel.cid =  self.cid;
inputModel.cgid =  self.cgid;

SMReportView *tView = [[SMReportView alloc] initWithFrame:self.view.bounds inputModel:inputModel];

```
## Author

304635659@qq.com, 304635659@qq.com

## License

MMTakeImage is available under the MIT license. See the LICENSE file for more info.

