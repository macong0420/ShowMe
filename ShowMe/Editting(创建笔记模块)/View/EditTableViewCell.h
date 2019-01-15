//
//  EditTableViewCell.h
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/14.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EditModle;

@interface EditTableViewCell : UITableViewCell

@property (nonatomic, strong) EditModle *model;

@end

NS_ASSUME_NONNULL_END
