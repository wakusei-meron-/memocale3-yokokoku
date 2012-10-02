//
//  InputView.h
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/14.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputViewDelegate;

@interface InputView : UIView<UITextFieldDelegate>
{
    UIImageView *imgDot,*imgDotMemo;
    UIButton *btnImp;
    int cancelOrDelete;
}

@property (nonatomic, retain)UITextField *txf;
@property (nonatomic, assign)id<InputViewDelegate> delegate;

- (void)cancelOrDelete:(int)sendint;
- (void)setCurrentColorAndImp:(NSInteger)charColor back:(NSInteger)backColor ImpOr:(int)imp;

@end

@protocol InputViewDelegate <NSObject>

- (void)deleteMemo;
- (void)okMemo:(UITextField *)txf;
- (void)judgeCharColor:(UIButton *)selectBtnColor;
- (void)judgeMemoColor:(UIButton *)selectBtnColor;
- (void)judgeImportant:(UIButton *)impBtn;
//- (void)cancelOrDelete:(int)cancelOrDelete;

@end
