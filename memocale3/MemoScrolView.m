//
//  MemoScrolView.m
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/19.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import "MemoScrolView.h"

#define space 60
#define lineInit 105

@implementation MemoScrolView
@synthesize imgView = _imgView;
@synthesize delegate2 = _delegate2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect imgViewFrame = CGRectMake(0.0, 0.0, 320, 825+45);
        self.imgView = [[[UIImageView alloc] initWithFrame:imgViewFrame] autorelease];
//        UILabel *strTime[18];
//        for (int i=0; i<18; i++) {
//            strTime[i] = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)] autorelease];
//            strTime[i].text = [NSString stringWithFormat:@"%2d:00",i+6];
//            strTime[i].center = CGPointMake(35, 40 + 40*i);
//            [self.imgView addSubview:strTime[i]];
//        }
//        [self drawLine];
        
        //scrView設定
        self.contentSize = self.imgView.frame.size;
        UIColor *backpatternImage = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"square-paper.png"]] autorelease];
//        UIColor *backpatternImage = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default.png"]] autorelease];
        self.backgroundColor = backpatternImage;
        [self addSubview:self.imgView];
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = NO;
        
        
        //doubleTapの実装
//        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
//        [doubleTapGesture setNumberOfTapsRequired:2];
//        [self.imgView addGestureRecognizer:doubleTapGesture];
    }
//    UIImageView *test = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default@2x.png"]];
//    NSLog(@"%@",NSStringFromCGRect(test.frame));
    
    return self;
}

- (void)drawLine
{
    UIGraphicsBeginImageContext(self.imgView.frame.size);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.3);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    for (int i=0; i<17; i++) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 52.5, lineInit + 45*i);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 301, lineInit + 45*i);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, lineInit - 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 320, lineInit - 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)setString
{
//    CGRect imgViewFrame = CGRectMake(0.0, 0.0, 320, 750);    
//    self.imgView = [[[UIImageView alloc] initWithFrame:imgViewFrame] autorelease];
    
    //スケジュールモード処理
    for (int i=0; i<18; i++) {
    strTime[i] = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] autorelease];
    strTime[i].text = [NSString stringWithFormat:@"%2d:00",i+6];
    strTime[i].center = CGPointMake(35, lineInit - 20 + 45*i);
        strTime[i].backgroundColor = [UIColor clearColor];
        [self.imgView addSubview:strTime[i]];
    }
    

    [self drawLine];
        
    strFree = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] autorelease];
    strFree.center = CGPointMake(35, 30);
    strFree.backgroundColor = [UIColor clearColor];
    strFree.text = @"Free";

    [self.imgView addSubview:strFree];
}

- (void)deleteSchedule
{
    //メモモード処理
    self.imgView.image = NULL;
    for (int i=0; i<18; i++) {
        [strTime[i] removeFromSuperview];
    }
    
    //フリースペース削除
    [strFree removeFromSuperview];
}

//ダブルタップ
- (void)doubleTap{
//    NSLog(@"tfai;jefo;");
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate2 oneTap];
    
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
