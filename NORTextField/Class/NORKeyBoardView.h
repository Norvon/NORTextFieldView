//
//  NORKeyBoardView.h
//  NORKeyBoard
//
//  Copyright © 2017年 nor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    kNORKeyBoardViewButtonType_NummberButton = 1,   //  输入内容的的button
    kNORKeyBoardViewButtonType_BottomLeftButton,
    kNORKeyBoardViewButtonType_BottomRightButton,
} NORKeyBoardViewButtonType;


@protocol NORKeyBoardViewDelegate <NSObject>

- (void)norKeyBoardViewBtnClick:(UIButton *)button buttonType:(NORKeyBoardViewButtonType)type;

@end

@interface NORKeyBoardView : UIView

/// 是否隐藏左下角按钮
@property (nonatomic, assign) BOOL hiddenBottomLeftButton;
 
/// 代理
@property (nonatomic, weak) id<NORKeyBoardViewDelegate> delegate;


/**
 初始化 NORKeyBoardView

 @param confusionKeyBoardNumber 是否对键盘进行打乱
 @return NORKeyBoardView
 */
- (instancetype)initWithConfusionKeyBoardNumber:(BOOL)confusionKeyBoardNumber;
@end
