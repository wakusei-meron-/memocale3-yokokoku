//
//  StaffView.m
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/24.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import "StaffView.h"

@implementation StaffView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor *backColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"square-paper.png"]];
        self.backgroundColor = backColor;
        UIImageView *topLabel = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up_banner.jpg"]]autorelease];
        CGRect topLabel_rect = CGRectMake(-1.0, 0.0, 321, 44);
        topLabel.frame = topLabel_rect;
        [self addSubview:topLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    NSLog(@"oiejfoaj");
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
