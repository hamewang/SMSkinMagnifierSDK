//
//  JFDCWIFIListCell.m
//  MoistureOil
//
//  Created by nana on 2020/4/23.
//  Copyright © 2020 idankee. All rights reserved.
//

#import "JFDCWIFIListCell.h"
#import <Masonry/Masonry.h>
#import "SMTool.h"

@implementation JFDCWIFIListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
//    self.backgroundColor =rgba(35, 33, 33, 1);
//    self.contentView.backgroundColor = rgba(35, 33, 33, 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.SSIDLabel = [[UILabel alloc] init];
    self.SSIDLabel.text = @"XXX";
    self.SSIDLabel.font = [UIFont systemFontOfSize:12];
    self.SSIDLabel.textColor = sm_RGBA(134, 133, 133, 1);
    [self.contentView addSubview:self.SSIDLabel];
    [self.SSIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(34.5);
        make.centerY.mas_equalTo(0);
    }];
    
    
    self.signalImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wifi_icon1"]];
    [self.contentView addSubview:self.signalImageView];
    [self.signalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = rgba(49, 49, 49, 1);
//    [self.contentView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(34.5);
//        make.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    self.choiceImageView.hidden = !selected;
//}


@end
