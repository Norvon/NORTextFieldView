//
//  NORTextFieldView.h
//  NORTextField
//
//  Copyright © 2017年 nor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NORTextFieldViewDelegate <NSObject>

@optional
/// 同textField 的 - (BOOL)textFieldView:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)norTextFieldView:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/// 同textField 的 - (void)textFieldViewDidEndEditing:(UITextField *)textField
- (void)norTextFieldViewDidEndEditing:(UITextField *)textField;
@end

@interface NORTextFieldView : UIView

/// textFile
@property (nonatomic, strong) UITextField * textField;

/// 是否对键盘进行打乱
@property (nonatomic, assign) BOOL isConfusion;

/// 是否隐藏键盘有右下角按钮
@property (nonatomic, assign) BOOL hiddenKeyBoardLeftBottomButton;

/// 代理
@property (nonatomic, weak) id<NORTextFieldViewDelegate> delegate;

@end
