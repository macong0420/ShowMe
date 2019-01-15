//
//  EditKeyBoardTopView.h
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/15.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditKeyBoardTopView;
NS_ASSUME_NONNULL_BEGIN

@protocol EditKeyBoardTopViewDelegate <NSObject>
@optional
- (void)editdidClick:(EditKeyBoardTopView *)keyboardView button:(UIButton *)button;

@end

@interface EditKeyBoardTopView : UIView

@property (nonatomic, weak) id <EditKeyBoardTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
