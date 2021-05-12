//
//  SMLinkSetThreeView.m
//  SkinMagnifier
//
//  Created by nana on 2021/4/12.
//

#import "SMLinkSetThreeView.h"
#import "SMTool.h"
#import <Masonry/Masonry.h>


@interface SMLinkSetThreeView()

@property(nonatomic, weak)UIView *lineView;

@end

@implementation SMLinkSetThreeView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *BigTipsLabel = [[UILabel alloc] init];
    BigTipsLabel.attributedText = sm_createAttString(@"第三步  设备配网", 25, sm_RGBA(76, 74, 66, 1));
    [self addSubview:BigTipsLabel];
    [BigTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(80);
    }];
    
    UILabel *tipsOneLabe = [[UILabel alloc] init];
    tipsOneLabe.attributedText = sm_createAttString(@"正在验证WiFi是否可用，请稍等", 15, sm_RGBA(153, 153, 153, 1));
    [self addSubview:tipsOneLabe];
    [tipsOneLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(BigTipsLabel.mas_bottom).offset(30);
    }];
    
    UIView *lineBGView = [[UIView alloc] init];
    lineBGView.layer.cornerRadius = 2.5;
    lineBGView.backgroundColor = sm_RGBA(221, 208, 203, 1);
    [self addSubview:lineBGView];
    [lineBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-210);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(255);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.layer.cornerRadius = 2.5;
    lineView.backgroundColor = sm_RGBA(255, 124, 82, 1);
    _lineView = lineView;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineBGView);
        make.top.equalTo(lineBGView);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(0);
    }];
    

    
}

- (void)progressValue:(CGFloat)pValue {
    [self setNeedsUpdateConstraints];;
    [UIView animateWithDuration:30 animations:^{

        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(255);
        }];
        [self layoutIfNeeded];
    }];
}

@end
