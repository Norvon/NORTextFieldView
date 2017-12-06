//
//  ViewController.m
//  NORTextField
//
//  Copyright © 2017年 nor. All rights reserved.
//

#import "ViewController.h"
#import "NORTextFieldView.h"

@interface ViewController ()<NORTextFieldViewDelegate>

@property (nonatomic, strong) NORTextFieldView * norTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.norTextField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.norTextField.textField resignFirstResponder];
}

#pragma mark - NORTextFieldViewDelegate
- (BOOL)norTextFieldView:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"--------------[nor shouldChangeCharactersInRange] Begin--------------");
    NSLog(@"textField: %@", textField);
    NSLog(@"range: %@", NSStringFromRange(range));
    NSLog(@"string: %@", string);
    NSLog(@"--------------[nor shouldChangeCharactersInRange] End--------------");
    
    return YES;
}

- (void)norTextFieldViewDidEndEditing:(UITextField *)textField
{
    NSLog(@"--------------[norTextFieldViewDidEndEditing] Begin--------------");
    NSLog(@"textField: %@", textField);
    NSLog(@"--------------[norTextFieldViewDidEndEditing] End--------------");
}

#pragma mark - 实例
- (NORTextFieldView *)norTextField
{
    if (_norTextField) {
        return _norTextField;
    }
    
    _norTextField             = [[NORTextFieldView alloc] init];
    _norTextField.frame       = CGRectMake(50, 50, 200, 30);
    _norTextField.delegate    = self;
    _norTextField.isConfusion = YES; // 是否打乱键盘
    _norTextField.hiddenKeyBoardLeftBottomButton = NO; // 是否隐藏 键盘左下角按钮
    
    return _norTextField;
}
@end
