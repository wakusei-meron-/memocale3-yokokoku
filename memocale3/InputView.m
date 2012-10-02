//
//  InputView.m
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/14.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InputView.h"
#import "AppDelegate.h"

@implementation InputView

#define cancelMode 0
#define deleteMode 1

//色について
#define BLACK 0
#define RED 1
#define BLUE 2
#define GREEN 3

//メモの色について
#define PWHITE 0
#define PYELLOW 1
#define PORANGE 2
#define PRED 3
#define PPINK 4
#define PPURPLE 5
#define PBLUE 6
#define PCYAN 7
#define PBLUEGREEN 8
#define PGREEN 9
#define PSUNGREEN 10
#define PBRAWN 11

@synthesize txf = _txf, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        
        CALayer *inputLayer = self.layer;
        inputLayer.cornerRadius = 10;
        
        //TextField
        float txf_posx = self.bounds.origin.x + 10.0f;
        float txf_posy = self.bounds.origin.y + 40.0f;
        float txf_width = self.frame.size.width-10.0*2;
        float txf_height = 30.0f;
        
        self.txf = [[[UITextField alloc] init] autorelease];
        self.txf.frame = CGRectMake( txf_posx, txf_posy, txf_width, txf_height);
//        self.txf.backgroundColor = [UIColor redColor];
        self.txf.borderStyle = UITextBorderStyleBezel;
        [self.txf becomeFirstResponder];
        [self addSubview:self.txf];
        self.txf.delegate = self;
        self.txf.backgroundColor = [UIColor colorWithRed:1.000 green:0.9 blue:0.8 alpha:1.0];
        self.txf.textAlignment = UITextAlignmentCenter;
        self.txf.returnKeyType = UIReturnKeyDone;
        
//        //削除ボタン
//        UIButton *btn_Trash = [UIButton buttonWithType:UIButtonTypeCustom];
////        [btn_Trash setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
//        [btn_Trash addTarget:self action:@selector(pushDeleteButton) forControlEvents:UIControlEventTouchUpInside];
//        btn_Trash.frame = CGRectMake(160, 168, 119, 29);
////        [self addSubview:btn_Trash];
//        NSLog(@"%d",cancelOrDelete);
//        if (cancelOrDelete == cancelMode) {
//            [btn_Trash setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
//        }else{
//            [btn_Trash setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//        }
//        [self addSubview:btn_Trash];
        
        //決定ボタン
        UIButton *btn_ok = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_ok setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [btn_ok addTarget:self action:@selector(pushOkButton) forControlEvents:UIControlEventTouchUpInside];
        btn_ok.frame = CGRectMake(15, 168, 119, 29);
        [self addSubview:btn_ok];
        
        //鉛筆
        UIImage *pencil = [UIImage imageNamed:@"3096.png"];
        UIImageView *img_pencil = [[[UIImageView alloc] initWithImage:pencil] autorelease];
        CGRect pencil_rect = CGRectMake(1, 85, 32, 32);
        img_pencil.frame = pencil_rect;
        [self addSubview:img_pencil];
        
        //書類
        UIImage *document = [UIImage imageNamed:@"document.png"];
        UIImageView *img_document = [[[UIImageView alloc] initWithImage:document] autorelease];
        CGRect document_rect = CGRectMake(90, 85, 22, 28);
        img_document.frame = document_rect;
        [self addSubview:img_document];
        
        //文字の色のボタン
//        UIButton *btnCharColor[8];
//        CGRect btnFrm[8];
//        for (int i=0; i<8; i++) {
//            btnCharColor[i] = [UIButton buttonWithType:UIButtonTypeCustom];
//            btnFrm[i] = CGRectMake(55 + 30*i, 85, 20, 20);
//            btnCharColor[i].frame = btnFrm[i];
//            [self addSubview:btnCharColor[i]];
//            btnCharColor[i].tag = i;
//            [btnCharColor[i] addTarget:self action:@selector(judgeCharColor:) forControlEvents:UIControlEventTouchDown];
//            btnCharColor[i].enabled = YES;
//        }
//        //色の指定
//        btnCharColor[0].backgroundColor = [UIColor blackColor];
//        btnCharColor[1].backgroundColor = [UIColor redColor];
//        btnCharColor[2].backgroundColor = [UIColor orangeColor];
//        btnCharColor[3].backgroundColor = [UIColor yellowColor];
//        btnCharColor[4].backgroundColor = [UIColor greenColor];
//        btnCharColor[5].backgroundColor = [UIColor cyanColor];
//        btnCharColor[6].backgroundColor = [UIColor blueColor];
//        btnCharColor[7].backgroundColor = [UIColor purpleColor];
        //文字の色のボタン
        UIButton *btnCharColor[4];
        CGRect btnFrm[4];
        for (int i=0; i<2; i++) {
            for (int j=0; j<2; j++) {
                int btnCharNum  = i*2 + j;
                btnCharColor[btnCharNum] = [UIButton buttonWithType:UIButtonTypeCustom];
                btnFrm[btnCharNum] = CGRectMake(33 + 30*j, 90 + 40*i, 22, 22);
                btnCharColor[btnCharNum].frame = btnFrm[btnCharNum];
                [self addSubview:btnCharColor[btnCharNum]];
                btnCharColor[btnCharNum].tag = btnCharNum;
                [btnCharColor[btnCharNum] addTarget:self action:@selector(judgeCharColor:) forControlEvents:UIControlEventTouchDown];
            }
        }
        
        //色の指定
        btnCharColor[0].backgroundColor = [self savedCharColor:BLACK];
        btnCharColor[1].backgroundColor = [self savedCharColor:RED];
        btnCharColor[2].backgroundColor = [self savedCharColor:BLUE];
        btnCharColor[3].backgroundColor = [self savedCharColor:GREEN];
        
//        //メモの色のボタン
//        UIButton *btnMemoColor[8];
//        CGRect btnFrm_2[8];
//        for (int i=0; i<8; i++) {
//            btnMemoColor[i] = [UIButton buttonWithType:UIButtonTypeCustom];
//            btnFrm_2[i] = CGRectMake(55 + 30*i, 125, 20, 20);
//            btnMemoColor[i].frame = btnFrm_2[i];
//            [self addSubview:btnMemoColor[i]];
//            btnMemoColor[i].tag = i;
//            [btnMemoColor[i] addTarget:self action:@selector(judgeMemoColor:) forControlEvents:UIControlEventTouchDown];
//            
//        }
//        //色の指定        
//        btnMemoColor[0].backgroundColor = [UIColor colorWithRed:1.000 green:0.9 blue:0.8 alpha:1.0];
//        btnMemoColor[1].backgroundColor = [UIColor colorWithRed:0.965 green:0.588 blue:0.475 alpha:1.0];
//        btnMemoColor[2].backgroundColor = [UIColor colorWithRed:0.976 green:0.678 blue:0.506 alpha:1.0];
//        btnMemoColor[3].backgroundColor = [UIColor colorWithRed:1.0 green:0.969 blue:0.600 alpha:1.0];
//        btnMemoColor[4].backgroundColor = [UIColor colorWithRed:0.769 green:0.875 blue:0.608 alpha:1.0];
//        btnMemoColor[5].backgroundColor = [UIColor colorWithRed:0.427 green:0.812 blue:0.965 alpha:1.0];
//        btnMemoColor[6].backgroundColor = [UIColor colorWithRed:0.514 green:0.576 blue:0.792 alpha:1.0];
//        btnMemoColor[7].backgroundColor = [UIColor colorWithRed:0.631 green:0.525 blue:0.749 alpha:1.0];

        //メモの色のボタン
        UIButton *btnMemoColor[12];
        CGRect btnMemoFrm[12];
        for (int i=0; i<2; i++) {
            for (int j=0; j<6; j++) {
                int btnMemoNum  = i*6 + j;
                btnMemoColor[btnMemoNum] = [UIButton buttonWithType:UIButtonTypeCustom];
                btnMemoFrm[btnMemoNum] = CGRectMake(120 + 30*j, 90 + 40*i, 22, 22);
                btnMemoColor[btnMemoNum].frame = btnMemoFrm[btnMemoNum];
                [self addSubview:btnMemoColor[btnMemoNum]];
                btnMemoColor[btnMemoNum].tag = btnMemoNum;
                [btnMemoColor[btnMemoNum] addTarget:self action:@selector(judgeMemoColor:) forControlEvents:UIControlEventTouchDown];
            }
        }
        
        //色の指定
        btnMemoColor[0].backgroundColor = [self savedMemoColor:PWHITE];
        btnMemoColor[1].backgroundColor = [self savedMemoColor:PYELLOW];
        btnMemoColor[2].backgroundColor = [self savedMemoColor:PORANGE];
        btnMemoColor[3].backgroundColor = [self savedMemoColor:PRED];
        btnMemoColor[4].backgroundColor = [self savedMemoColor:PPINK];
        btnMemoColor[5].backgroundColor = [self savedMemoColor:PPURPLE];
        btnMemoColor[6].backgroundColor = [self savedMemoColor:PBLUE];
        btnMemoColor[7].backgroundColor = [self savedMemoColor:PCYAN];        
        btnMemoColor[8].backgroundColor = [self savedMemoColor:PBLUEGREEN];        
        btnMemoColor[9].backgroundColor = [self savedMemoColor:PGREEN];        
        btnMemoColor[10].backgroundColor = [self savedMemoColor:PSUNGREEN];        
        btnMemoColor[11].backgroundColor = [self savedMemoColor:PBRAWN];        
        
        //ドット
        imgDot = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot.png"]] autorelease];
        imgDot.frame = CGRectMake(0, 0, 10, 10);
        [self addSubview:imgDot];
        imgDotMemo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot.png"]] autorelease];
        imgDotMemo.frame = CGRectMake(0, 0, 10, 10);
        [self addSubview:imgDotMemo];
        
        //重要ボタン
        btnImp = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnImp addTarget:self action:@selector(pushImpBtn:) forControlEvents:UIControlEventTouchUpInside];
        CGRect btnImpFrm = CGRectMake(220, 5, 50 , 28);
        btnImp.frame = btnImpFrm;
        [btnImp setImage:[UIImage imageNamed:@"imp2.png"] forState:UIControlStateNormal];
        [self addSubview:btnImp];
        
        
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txf resignFirstResponder];
    
    return YES;
}

//削除ボタン
- (void)pushDeleteButton
{
    
    //delegateで呼び出す
    [self.delegate deleteMemo];
}
- (void)pushOkButton
{
    [self.delegate okMemo:self.txf];
}

- (void)judgeCharColor:(UIButton *)selectBtnColor
{
    CGPoint dot_point;
    [self.delegate judgeCharColor:selectBtnColor];
    if (selectBtnColor.tag < 2) {
        dot_point = CGPointMake(44 + 30*selectBtnColor.tag, 80);
    }else {
        dot_point = CGPointMake(44 + 30*(selectBtnColor.tag-2), 120);
    }
    imgDot.center = dot_point;
//    NSLog(@"tag is: %d",selectBtnColor.tag);
//    CALayer *layer = selectBtnColor.layer;
//    layer.shadowColor = [[UIColor whiteColor] CGColor];
//    layer.shadowOffset = CGSizeMake(0, 1.0);
//    layer.shadowOpacity = 0.5;
    
}

- (void)judgeMemoColor:(UIButton *)selectBtnColor
{
    CGPoint dot_center;
    [self.delegate judgeMemoColor:selectBtnColor];
    if (selectBtnColor.tag < 6) {
        dot_center = CGPointMake(131 + 30*selectBtnColor.tag, 80);
    }else {
        dot_center = CGPointMake(131 + 30*(selectBtnColor.tag - 6), 120);
    }
    imgDotMemo.center = dot_center;
    
}

- (void)cancelOrDelete:(int)sendint
{
    cancelOrDelete = sendint;
    //削除ボタン
    UIButton *btn_Trash = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [btn_Trash setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [btn_Trash addTarget:self action:@selector(pushDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    btn_Trash.frame = CGRectMake(160, 168, 119, 29);
    //        [self addSubview:btn_Trash];
//    if (cancelOrDelete == cancelMode) {
        [btn_Trash setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
//    }else{
//        [btn_Trash setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//    }
    [self addSubview:btn_Trash];
}

- (void)setCurrentColorAndImp:(int)charColor back:(NSInteger)backColor ImpOr:(int)imp
{
//    NSLog(@"後：%d %d",charColor,backColor);
    CGPoint initialCharPoint;
    if (charColor < 2) {
        initialCharPoint = CGPointMake(44 + 30*charColor, 80);
    }else {
        initialCharPoint = CGPointMake(44 + 30*(charColor  -2), 120);
    }
    CGPoint initialMemoPoint;
    if (backColor < 6) {
        initialMemoPoint = CGPointMake(131 + 30*backColor, 80);
    }else {
        initialMemoPoint = CGPointMake(131 + 30*(backColor - 6), 120);
    }
        
    imgDot.center = initialCharPoint;
    imgDotMemo.center = initialMemoPoint;
    self.txf.textColor = [self savedCharColor:charColor];
    self.txf.backgroundColor = [self savedMemoColor:backColor];
    
    //重要かどうかの判定
    if (imp == 0) {
        [btnImp setImage:[UIImage imageNamed:@"imp2.png"] forState:UIControlStateNormal];
        btnImp.tag = 0;
    }else {
        [btnImp setImage:[UIImage imageNamed:@"important.png"] forState:UIControlStateNormal];
        btnImp.tag = 1;
    }
}

- (UIColor *)savedCharColor:(int)colorNum
{
    //文字の色について
    switch (colorNum) {
        case BLACK:
            return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; 
            break;
            
        case RED:
            return [UIColor colorWithRed:229/255.0 green:6/255.0 blue:21/255.0 alpha:1.0];
            break;
            
        case BLUE:
            return [UIColor colorWithRed:0/255.0 green:58/255.0 blue:169/255.0 alpha:1.0];
            break;
            
        case GREEN:
            return [UIColor colorWithRed:0.0 green:143/255.0 blue:59/255.0 alpha:1.0];
            break;
            
//        case GREEN:
//            return [UIColor greenColor];
//            break;
//            
//        case cyan:
//            return [UIColor cyanColor];
//            break;
//            
//        case BLUE:
//            return [UIColor blueColor];
//            break;
//            
//        case purple:
//            return [UIColor purpleColor];
//            break;
            
        default:
            break;
    }
    return nil;
}

- (UIColor *)savedMemoColor:(int)colorNum
{
    //文字の色について
    switch (colorNum) {
        case PWHITE:
            return [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
            break;
            
        case PYELLOW:
            return [UIColor colorWithRed:1.00 green:249/255.0 blue:159/255.0 alpha:1.0];
            break;
            
        case PORANGE:
            return [UIColor colorWithRed:250/255.0 green:216/255.0 blue:158/255.0 alpha:1.0];
            break;
            
        case PRED:
            return [UIColor colorWithRed:245/255.0 green:162/255.0 blue:167/255.0 alpha:1.0];
            break;
            
        case PPINK:
            return [UIColor colorWithRed:245/255.0 green:180/255.0 blue:207/255.0 alpha:1.0];
            break;
            
        case PPURPLE:
            return [UIColor colorWithRed:210/255.0 green:170/255.0 blue:210/255.0 alpha:1.0];
            break;
            
        case PBLUE:
            return [UIColor colorWithRed:196/255.0 green:170/255.0 blue:210/255.0 alpha:1.0];
            break;
            
        case PCYAN:
            return [UIColor colorWithRed:159/255.0 green:219/255.0 blue:246/255.0 alpha:1.0];
            break;
            
        case PBLUEGREEN:
            return [UIColor colorWithRed:159/255.0 green:221/255.0 blue:216/255.0 alpha:1.0];
            break;
            
        case PGREEN:
            return [UIColor colorWithRed:159/255.0 green:213/255.0 blue:182/255.0 alpha:1.0];
            break;
            
        case PSUNGREEN:
            return [UIColor colorWithRed:212/255.0 green:232/255.0 blue:172/255.0 alpha:1.0];
            break;
            
        case PBRAWN:
            return [UIColor colorWithRed:218/255.0 green:203/255.0 blue:172/255.0 alpha:1.0];
            break;
        default:
            break;
    }
    return nil;                                                 
}

- (void)pushImpBtn:(UIButton *)btn
{
    if (btn.tag == 0) {
        [btn setImage:[UIImage imageNamed:@"important.png"] forState:UIControlStateNormal];
        btn.tag = 1;
    }else {
        [btn setImage:[UIImage imageNamed:@"imp2.png"] forState:UIControlStateNormal];
        btn.tag = 0;
    }
    [self.delegate judgeImportant:btn];
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
