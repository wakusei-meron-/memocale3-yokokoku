//
//  CallendarView_year.h
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/23.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayButton.h"

@protocol CalendarViewDelegate <NSObject>

- (void)dayButtonPressed:(DayButton *)button;
- (void)dayButtonDoubleTap:(DayButton *)button;

@optional
- (void)prevButtonPressed;
- (void)nextButtonPressed;

@end

@interface CallendarView_year : UIView<DayButtonDelegate>{
    id <CalendarViewDelegate> delegate;
    NSString *calendarFontname;
    UILabel *monthLabel;
    UIImageView *dayLabel[7];
    //NSMutableArray *dayButtons;
    NSCalendar *calendar;
    float calendarWidth;
    float calendarHeight;
    float cellWidth;
    float cellHeight;
    float logoHeight;
    float topLabelHeight;
    float dayLabelHeight;
    int currentMonth;
    int currentYear;
    
    UILabel *scdBtn;
    int vacationFlag;
    CGRect initFrm;
    
}

@property(nonatomic, assign)id<CalendarViewDelegate> delegate;
@property(nonatomic, retain)NSMutableArray *dayButtons;

-(id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate;
-(void)updateCalendarForMonth:(int)month forYear:(int)year;
-(void)drawDayButtons;
-(void)prevBtnPressed:(id)sender;
-(void)nextBtnPressed:(id)sender;
-(void)insertTodayInformation:(int)month todayYear:(int)year;
-(void)syuu_preference:(int)syuu;


@end
