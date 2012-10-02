//
//  MemoView.h
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/24.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Action.h"

@protocol MemoViewDelegate;



@interface MemoView : UIView<UIGestureRecognizerDelegate>{
    CGPoint startPoint;
    CGPoint newPoint;
    UILabel *lbl_memo;
    CALayer *layer;
    id <MemoViewDelegate> delegate;
    
    int memoID;
    int scrMode;
    UIButton *deletebtn;
    int deleteMode;
    
    NSTimer *timer;
}

@property (nonatomic, retain)UILabel *lbl_memo;
@property (nonatomic, copy)UIColor *lbl_color;
@property (nonatomic, assign)id <MemoViewDelegate> delegate;
@property (nonatomic, retain)Action *action;
- (void)setFrameSize:(unsigned int)char_number;
- (void)setMemoId:(int)id_;
- (int)getMemoId;
- (void)lblResize;
- (void)setScrMode:(int)Mode;
- (void)resetOverMemo;
- (void)longTap:(UILongPressGestureRecognizer *)gesture;
- (void)appearDeleteBtn;
- (void)disappearDeleteBtn;
- (void)pushDeleteBtn;
- (void)checkImp;
@end






@protocol MemoViewDelegate <NSObject>

- (void)moveMemo:(CGPoint)origin selectedMemo:(Action *)moveAction;
- (void)doubleTap:(MemoView *)selectView;//(Action *)selectedAction;
- (void)setMode:(MemoView *)selectView;
- (void)deleteModeOn;
- (void)pushedDeleteBtn:(MemoView *)deleteMemo;

@end