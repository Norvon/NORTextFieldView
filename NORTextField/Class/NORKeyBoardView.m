//
//  NORKeyBoardView.m
//  NORKeyBoard
//
//  Copyright © 2017年 nor. All rights reserved.
//

#import "NORKeyBoardView.h"
#import "UIView+FrameExtension.h"


#define kKeyBoardViewBtnTopMargin     8.f // 默认顶部间距
#define kKeyBoardViewBtnBottomMargin  5.f  // 默认底部间距
#define kKeyBoardViewBtnLeftMargin    5.f  // 默认left间距
#define kKeyBoardViewBtnColMargin     5.f  // 默认列间距
#define kKeyBoardViewBtnRowMargin     5.f  // 默认行间距

#define kKeyBoardViewBtnWidth ((self.frame.size.width - 2 * kKeyBoardViewBtnLeftMargin - 2 * kKeyBoardViewBtnColMargin) / 3) // 按钮宽度
#define kKeyBoardViewBtnHight ((self.frame.size.height - kKeyBoardViewBtnTopMargin - kKeyBoardViewBtnBottomMargin - 3 * kKeyBoardViewBtnRowMargin) / 4) // 按钮高度

#define RGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]) // RGB 宏


@interface NORKeyBoardView ()

@property (nonatomic, strong) NSArray * numberButotnArray;

@property (nonatomic, strong) UIButton * bottomRightButton;

@property (nonatomic, strong) UIButton * bottomLeftButton;

@property (nonatomic, strong) NSMutableArray * btnArrayM;

@end

@implementation NORKeyBoardView

- (instancetype)initWithConfusionKeyBoardNumber:(BOOL)confusionKeyBoardNumber
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor colorWithRed:0xdf/255.0 green:0xdd/255.0 blue:0xdd/255.0 alpha:1.0f];
        
        if (confusionKeyBoardNumber)
        {
            self.numberButotnArray = [self getConfusionArrayWithArray:self.numberButotnArray];
        }

        [self initView];
    }
    return self;
}

- (void)initView
{
    [self addSubViewWithNumberBtn];
    [self addSubview:self.bottomRightButton];
    [self addSubview:self.bottomLeftButton];
}

- (void) addSubViewWithNumberBtn
{
    // 循环创建10个数字按钮
    for (int i = 0 ; i < self.numberButotnArray.count; ++i)
    {
        UIButton * numBtn      = [[UIButton alloc] init];
        numBtn.tag             = kNORKeyBoardViewButtonType_NummberButton;
        numBtn.titleLabel.font = [UIFont systemFontOfSize:22.f];
        
        [numBtn setTitle:self.numberButotnArray[i] forState:UIControlStateNormal];
        [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        [numBtn setBackgroundImage:[UIImage imageNamed:@"blcak"] forState:UIControlStateSelected];
        [numBtn addTarget:self action:@selector(keyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:numBtn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupUI];
}

- (void)setupUI
{
    // 0数字位置
    UIButton * buttonZero = self.subviews[0];
    buttonZero.height     = kKeyBoardViewBtnHight;
    buttonZero.width      = kKeyBoardViewBtnWidth;
    buttonZero.centerX    = self.centerX;
    buttonZero.centerY    = self.height - kKeyBoardViewBtnBottomMargin - buttonZero.height / 2;

    // 布局其他数字
    for (int i = 1; i < self.numberButotnArray.count; i++)
    {
        UIButton * btn = self.subviews[i];
        CGFloat row = (i - 1) / 3;
        CGFloat col = (i - 1) % 3;
        
        btn.x      = kKeyBoardViewBtnLeftMargin + col * (kKeyBoardViewBtnWidth + kKeyBoardViewBtnColMargin);
        btn.y      = kKeyBoardViewBtnTopMargin + row * (kKeyBoardViewBtnHight + kKeyBoardViewBtnRowMargin);
        btn.width  = kKeyBoardViewBtnWidth;
        btn.height = kKeyBoardViewBtnHight;
    }

    // bottomRightButton
    self.bottomRightButton.x      = CGRectGetMaxX(buttonZero.frame) + kKeyBoardViewBtnColMargin;
    self.bottomRightButton.y      = buttonZero.y;
    self.bottomRightButton.width  = buttonZero.width;
    self.bottomRightButton.height = buttonZero.height;

    // bottomLeftButton
    self.bottomLeftButton.x      = kKeyBoardViewBtnLeftMargin;
    self.bottomLeftButton.y      = buttonZero.y;
    self.bottomLeftButton.width  = buttonZero.width;
    self.bottomLeftButton.height = buttonZero.height;
}


/**
 输入一个数组, 得到一个打乱的数组

 @param array 输入数组
 @return 返回打乱的数组
 */
- (NSArray *)getConfusionArrayWithArray:(NSArray *)array
{
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    NSMutableArray * confusionArrayM = [NSMutableArray array];
    for (int i = 0; i < array.count; ++i)
    {
        if (i == 0)
        {
            [confusionArrayM insertObject:array[i] atIndex:i];
        }
        else
        {
            int randomNumber = arc4random_uniform((uint32_t)(confusionArrayM.count + 1));
            [confusionArrayM insertObject:array[i] atIndex:randomNumber];
        }
    }
    
    return confusionArrayM.copy;
}


#pragma mark - ButtonClick
- (void)keyboardButtonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(norKeyBoardViewBtnClick:buttonType:)])
    {
        [self.delegate norKeyBoardViewBtnClick:btn buttonType:[self getKeyBoardViewButtonTypeWithButtonTag:btn.tag]];
    }
}

- (NORKeyBoardViewButtonType)getKeyBoardViewButtonTypeWithButtonTag:(NSUInteger)tag
{
    NORKeyBoardViewButtonType type = kNORKeyBoardViewButtonType_NummberButton;
    switch (tag) {
        case 1:
            type = kNORKeyBoardViewButtonType_NummberButton;
            break;
        case 2:
            type = kNORKeyBoardViewButtonType_BottomLeftButton;
            break;
        case 3:
            type = kNORKeyBoardViewButtonType_BottomRightButton;
            break;
            
        default:
            break;
    }
    
    return type;
}

#pragma mark - set
- (void)setHiddenBottomLeftButton:(BOOL)hiddenBottomLeftButton
{
    _hiddenBottomLeftButton = hiddenBottomLeftButton;
    self.bottomLeftButton.hidden = hiddenBottomLeftButton;
}

#pragma mark - 实例
- (NSArray *)numberButotnArray
{
    if (_numberButotnArray) {
        return _numberButotnArray;
    }
    
    _numberButotnArray = [NSMutableArray array];
    _numberButotnArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    
    return _numberButotnArray;
}

- (UIButton *)bottomRightButton
{
    if (_bottomRightButton)
    {
        return _bottomRightButton;
    }

    _bottomRightButton                 = [[UIButton alloc] init];
    _bottomRightButton.tag             = kNORKeyBoardViewButtonType_BottomRightButton;
    _bottomRightButton.width           = kKeyBoardViewBtnWidth;
    _bottomRightButton.height          = kKeyBoardViewBtnHight;
    _bottomRightButton.contentMode     = UIViewContentModeCenter;
    _bottomRightButton.titleLabel.font = [UIFont systemFontOfSize:22.f];
    
    [_bottomRightButton setTitle:@"Del" forState:UIControlStateNormal];
    [_bottomRightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bottomRightButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
    [_bottomRightButton setBackgroundImage:[UIImage imageNamed:@"blcak"] forState:UIControlStateSelected];
    [_bottomRightButton addTarget:self action:@selector(keyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _bottomRightButton;
}

- (UIButton *)bottomLeftButton
{
    if (_bottomLeftButton)
    {
        return _bottomLeftButton;
    }
    
    _bottomLeftButton                 = [[UIButton alloc] init];
    _bottomLeftButton.tag             = kNORKeyBoardViewButtonType_BottomLeftButton;
    _bottomLeftButton.width           = kKeyBoardViewBtnWidth;
    _bottomLeftButton.height          = kKeyBoardViewBtnHight;
    _bottomLeftButton.contentMode     = UIViewContentModeCenter;
    _bottomLeftButton.titleLabel.font = [UIFont systemFontOfSize:22.f];

    [_bottomLeftButton setTitle:@"X" forState:UIControlStateNormal];
    [_bottomLeftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bottomLeftButton setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
    [_bottomLeftButton setBackgroundImage:[UIImage imageNamed:@"blcak"] forState:UIControlStateSelected];
    [_bottomLeftButton addTarget:self action:@selector(keyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _bottomLeftButton;
}

@end
