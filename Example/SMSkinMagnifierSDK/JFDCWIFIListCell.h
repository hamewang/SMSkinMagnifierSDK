//
//  JFDCWIFIListCell.h
//  MoistureOil
//
//  Created by nana on 2020/4/23.
//  Copyright © 2020 idankee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///WiFi 列表的cell
@interface JFDCWIFIListCell : UITableViewCell

@property(nonatomic , strong)UILabel    *SSIDLabel;
@property(nonatomic, strong)UIImageView *signalImageView;
@property(nonatomic, strong)NSString *accountString;
@property(nonatomic, strong)NSString *pwdString;
@end

NS_ASSUME_NONNULL_END
