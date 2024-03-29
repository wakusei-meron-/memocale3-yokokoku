//
//  DayButton.h
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/23.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DayButtonDelegate;

@interface DayButton : UIButton{
    id <DayButtonDelegate> delegate;
    NSDate *buttonDate;
    UILabel *lbl_NumMemo;
}

@property (nonatomic, assign)id <DayButtonDelegate> delegate;
@property (nonatomic, copy)NSDate *buttonDate;

- (id)buttonWithFrame:(CGRect)buttonFrame;
- (void)sarch_num;
- (void)setTodayColor;
- (void)returnColor;
@end

@protocol DayButtonDelegate <NSObject>

- (void)dayButtonPressed:(id)sender;
- (void)buttonDoubleTap:(id)sender;

@end
