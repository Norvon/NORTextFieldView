//
//  NORTextFieldView.m
//  NORTextField
//
//  Copyright © 2017年 nor. All rights reserved.
//

#import "NORTextFieldView.h"
#import "NORKeyBoardView.h"

@interface NORTextFieldView ()<
                                UITextFieldDelegate,
                                NORKeyBoardViewDelegate>

@end

@implementation NORTextFieldView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.textField];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NORKeyBoardView * keyBoardView       = [[NORKeyBoardView alloc] initWithConfusionKeyBoardNumber:self.isConfusion];
    keyBoardView.frame                   = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216,
                                                     [UIScreen mainScreen].bounds.size.width, 216);
    keyBoardView.delegate                = self;
    keyBoardView.hiddenBottomLeftButton  = self.hiddenKeyBoardLeftBottomButton;
    
    self.textField.inputView = keyBoardView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return [self norTextField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self norTextFieldDidEndEditing:textField withString:@""];
}

#pragma mark - NORKeyBoardViewDelegate
- (void)norKeyBoardViewBtnClick:(UIButton *)button buttonType:(NORKeyBoardViewButtonType)type
{
    if(type == kNORKeyBoardViewButtonType_BottomRightButton)
    {
        [self norTextFieldDidDelete:self.textField];
    }
    else
    {
        // 获取当前光标位置
        NSRange range = [self rangeFromTextRange:self.textField.selectedTextRange inTextField:self.textField];
        
        if ([self norTextField:self.textField shouldChangeCharactersInRange:range replacementString:button.titleLabel.text])
        {
            [self norTextFieldDidEndEditing:self.textField withString:button.titleLabel.text];
        }
    }
}

/**
 开始编辑

 @param textField 编辑的textField
 @param range 编辑的位置
 @param string 传入字符串
 @return 返回是否可以进行编辑
 */
- (BOOL)norTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(norTextFieldView:shouldChangeCharactersInRange:replacementString:)])
    {
        return [self.delegate norTextFieldView:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (void)norTextFieldDidEndEditing:(UITextField *)textField withString:(NSString *)string
{
    NSMutableString * textFieldTextM = [NSMutableString stringWithString:textField.text];
    
    NSRange range = [self rangeFromTextRange:textField.selectedTextRange inTextField:textField];
    
    [textFieldTextM replaceCharactersInRange:range withString:string];
    
    textField.text = textFieldTextM.copy;
    
    //  设置光标位置
    [self norTextField:textField setSelectedRange:NSMakeRange(range.location + 1, range.length)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(norTextFieldViewDidEndEditing:)])
    {
        [self.delegate norTextFieldViewDidEndEditing:textField];
    }
    
}

/// 删除处理
- (void)norTextFieldDidDelete:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        return;
    }
    
    //  光标当前位置
    NSRange range = [self rangeFromTextRange:textField.selectedTextRange inTextField:textField];
    
    NSMutableString * textFieldTextM = [NSMutableString stringWithString:textField.text];
    if (textField.selectedTextRange.empty)
    {
        range.length   = 1;
        
        if (range.location == 0)
        {
            return;
        }
        range.location = range.location - 1;
        
        [textFieldTextM deleteCharactersInRange:range];
        
        textField.text = textFieldTextM.copy;
    }
    else
    {
        [textFieldTextM deleteCharactersInRange:range];
        
        textField.text = textFieldTextM.copy;
    }
    
    // 设置光标位置
    [self norTextField:textField setSelectedRange:NSMakeRange(range.location, 0)];
}

/**
 转换 UITextRange 为 NSRange
 
 @param textRange UITextRange
 @param textField testField
 @return NSRange
 */
- (NSRange)rangeFromTextRange:(UITextRange *)textRange inTextField:(UITextField *)textField
{
    UITextPosition * start     = textRange.start;
    UITextPosition * end       = textRange.end;
    UITextPosition * beginning = textField.beginningOfDocument;
    
    const NSInteger location   = [textField offsetFromPosition:beginning toPosition:start];
    const NSInteger length     = [textField offsetFromPosition:start toPosition:end];
    
    return NSMakeRange(location, length);
}

/**
 设置UITextField的位置 (UITextField必须为第一响应者才有效)

 @param textField textField
 @param range range
 */
- (void)norTextField:(UITextField *)textField setSelectedRange:(NSRange) range
{
    UITextPosition * beginning = textField.beginningOfDocument;
    
    UITextPosition * startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition * endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange * selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    
    [textField setSelectedTextRange:selectionRange];
}

#pragma mark - 实例
- (UITextField *)textField
{
    if (_textField) {
        return _textField;
    }
    
    _textField                 = [[UITextField alloc] init];
    _textField.font            = [UIFont systemFontOfSize:15];
    _textField.frame           = self.bounds;
    _textField.delegate        = self;
    _textField.borderStyle     = UITextBorderStyleRoundedRect;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return _textField;
}
@end
