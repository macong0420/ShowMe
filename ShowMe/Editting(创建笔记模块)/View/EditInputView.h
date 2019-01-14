//
//  EditInputView.h
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/14.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditInputView : UIView

@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UITextField *titleField;//标题

@end

NS_ASSUME_NONNULL_END
