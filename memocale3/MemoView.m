//
//  MemoView.m
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/24.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import "MemoView.h"

@implementation MemoView
@synthesize lbl_memo;
@synthesize lbl_color;
@synthesize delegate;
@synthesize action = _action;

#define deleteModeYes 0
#define deleteModeNo 1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        CGRect lbl_frame = CGRectMake(1, 1, frame.size.width-2, frame.size.height-2);
        lbl_memo = [[UILabel alloc] initWithFrame:lbl_frame];
//        lbl_memo.backgroundColor = [UIColor clearColor];
        lbl_memo.textAlignment = UITextAlignmentCenter;
        lbl_memo.minimumFontSize = 15;
        
        //CALayer
        layer = self.layer;
//        layer.shadowColor = [[UIColor whiteColor] CGColor];
//        layer = NULL;
        layer.shadowColor = [[UIColor blackColor] CGColor];
//        layer.shadowOpacity = 0.5;
        
//        layer.cornerRadius = 3;
        
        [self addSubview:lbl_memo];
        
        //タップの反応
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture)];
        [doubleTapGesture setNumberOfTapsRequired:2];
//        [doubleTapGesture setNumberOfTouchesRequired:2];
        [self addGestureRecognizer:doubleTapGesture];
        [doubleTapGesture release];
        
//        //長押しの反応
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
        longPressGesture.minimumPressDuration = 1.0;
        longPressGesture.delegate = self;
        [self addGestureRecognizer:longPressGesture];
        [longPressGesture release];

        
        //削除ボタン
        deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebtn.frame = CGRectMake(0, 0, 60, 60);
        
        //追加(UIImageの大きさ指定)
//        UIImage *btnImage = [UIImage imageNamed:@"batu.png"];
        // リサイズ例文（サイズを指定する方法）
        UIImage *img_mae = [UIImage imageNamed:@"batu.png"];  // リサイズ前UIImage
        UIImage *img_ato;  // リサイズ後UIImage
        CGFloat width = 30;  // リサイズ後幅のサイズ
        CGFloat height = 30;  // リサイズ後高さのサイズ
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [img_mae drawInRect:CGRectMake(0, 0, width, height)];
        img_ato = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext(); 
        
        
//        [deletebtn setImage:[UIImage imageNamed:@"batu.png"] forState:UIControlStateNormal];
        [deletebtn setImage:img_ato forState:UIControlStateNormal];
        deletebtn.center = CGPointMake(self.bounds.origin.x+8, 8+self.bounds.origin.y);
        [deletebtn addTarget:self action:@selector(pushDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deletebtn];
        

//        [self checkImp];
//        if ([self.action.scrOrMemo intValue] == 1) {
//            [deletebtn setImage:[UIImage imageNamed:@"hanamaru.png"] forState:UIControlStateNormal];
//            deletebtn.enabled = NO;
//        }else {
//            deletebtn.hidden = YES;
//
//        }
                deleteMode = 1;
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //superにModeを代入してもらう
    [self.delegate setMode:self];
    
    startPoint = [[touches anyObject] locationInView:self];
    [self.superview bringSubviewToFront:self];
    CGPoint beginningPoint = [[touches anyObject] locationInView:self.superview];
    beginningPoint.x -= startPoint.x;
    beginningPoint.y -= startPoint.y;
    newPoint = beginningPoint;
    
    //影有効
    layer.shadowOffset = CGSizeMake(2.5, 2.5);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOpacity = 0.5;
    layer.hidden = NO;
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    newPoint = [[touches anyObject] locationInView:self.superview];
    newPoint.x -= startPoint.x;
    newPoint.y -= startPoint.y;
    //動く範囲の指定
    //上の限界の指定
    if (newPoint.y < 0) {
        newPoint.y = 0;
    }
    
    //下の限界の指定
    //scrModeのとき
    if (scrMode == 1) {
        if (newPoint.y > self.superview.bounds.size.height-30) {
            newPoint.y = self.superview.bounds.size.height-30;
        }
    }else if(scrMode == 0){
        if (newPoint.y > 825-30+45) {
            newPoint.y = 825-30+45;
        }
    }
    //左の限界
    if (newPoint.x < -self.bounds.size.width+30) {
        newPoint.x = -self.bounds.size.width+30;
    }
    
    //右の限界
    if (newPoint.x > self.superview.bounds.size.width - 30) {
        newPoint.x = self.superview.bounds.size.width - 30;
    }
    
    CGRect frm = [self frame];
    frm.origin = newPoint;
    [self setFrame:frm];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

//    [delegate moveMemo:newPoint selectedMemo:self.action];
    [delegate moveMemo:self.center selectedMemo:self.action];
    
    //影無効
    layer.shadowColor = [[UIColor whiteColor] CGColor];
    
    
}

- (void)setFrameSize:(unsigned int)char_number
{
    
}

//IDの代入
- (void)setMemoId:(int)id_{
    memoID = id_;
}

//IDを渡す
- (int)getMemoId{
    return memoID;
}

//ダブルタップされた時
- (void)doubleTapGesture
{
    [delegate doubleTap:self];
    layer.shadowColor = [[UIColor whiteColor] CGColor];
}

//文字数によるリサイズ
- (void)lblResize
{
    CGRect lbl_rect = CGRectMake(self.bounds.origin.x+1, self.bounds.origin.y+1, self.bounds.size.width-2, self.bounds.size.height-2);
    lbl_memo.frame = lbl_rect;
}

//scrModeかどうかを代入
- (void)setScrMode:(int)Mode
{
    scrMode = Mode;
}

//下にあるmemoを上に持ってくる
- (void)resetOverMemo
{
    if (self.superview.bounds.origin.y > self.superview.bounds.size.height-74) {
        CGPoint memo_rect = CGPointMake(self.superview.bounds.origin.x + self.bounds.size.width/2.0, self.superview.bounds.size.height-74);
        self.center = memo_rect;
    }
 
    
}


//ロングタップされたら…
- (void)longTap:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        layer.shadowColor = [[UIColor whiteColor] CGColor];

//        //影有効
//        layer.shadowOffset = CGSizeMake(2.5, 2.5);
//        layer.shadowColor = [[UIColor blackColor] CGColor];
//        layer.shadowOpacity = 0.5;
//        layer.hidden = NO;
    
        if (deleteMode == deleteModeNo) {
            [self.delegate deleteModeOn];
            
        }
        deletebtn.enabled = YES;
//        [deletebtn setImage:[UIImage imageNamed:@"batu.png"] forState:UIControlStateNormal];
        // リサイズ例文（サイズを指定する方法）
        UIImage *img_mae = [UIImage imageNamed:@"batu.png"];  // リサイズ前UIImage
        UIImage *img_ato;  // リサイズ後UIImage
        CGFloat width = 30;  // リサイズ後幅のサイズ
        CGFloat height = 30;  // リサイズ後高さのサイズ
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [img_mae drawInRect:CGRectMake(0, 0, width, height)];
        img_ato = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [deletebtn setImage:img_ato forState:UIControlStateNormal];
    }
}

//デリートボタンの表示
- (void)appearDeleteBtn
{
    deletebtn.hidden = NO;
    
    //影の有効
//    layer = self.layer;
//    layer.shadowColor = [[UIColor blackColor] CGColor];
//    NSLog(@"%@",layer);
}

//デリートボタンの非表示
- (void)disappearDeleteBtn
{
    deletebtn.hidden = YES;
    
    layer.shadowColor = [[UIColor whiteColor] CGColor];
    [self checkImp];
//    layer.hidden = YES;
}

//デリートボタンが押されたら
- (void)pushDeleteBtn
{
    [self.delegate pushedDeleteBtn:self];
}

//揺らす
- (void)buruburu
{
//    if (deletebtn.hidden == NO) {
//        float omega;
//        float theta = sinf(<#float#>)
//        self.transform = CGAffineTransformMakeRotation(<#CGFloat angle#>)
//    }
}

//重要かそうでないかチェック
- (void)checkImp
{
    if ([self.action.scrOrMemo intValue] == 1) {
        [deletebtn setImage:[UIImage imageNamed:@"hanamaru.png"] forState:UIControlStateNormal];
        deletebtn.enabled = NO;
        deletebtn.hidden = NO;
    }else {
        deletebtn.hidden = YES;
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
