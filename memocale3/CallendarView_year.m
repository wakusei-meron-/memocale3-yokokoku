//
//  CallendarView_year.m
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/23.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import "CallendarView_year.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation CallendarView_year
@synthesize delegate, dayButtons = _dayButtons;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate
{
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
        self.delegate = theDelegate;
        
        //initialization
        calendarFontname = fontName;
        calendarWidth = frame.size.width;
        calendarHeight = frame.size.height;
        cellWidth = frame.size.width/7.0f;
//        cellHeight = frame.size.height/9.0f;
        
        topLabelHeight = frame.size.height/11.0f;
        logoHeight = frame.size.height/9.0f;
        cellHeight = (frame.size.height - topLabelHeight -logoHeight)/7.0;
        
        //Viewproperties背景とか
        
        //Set up the calendar header
        //Back Button
        UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [prevBtn setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
        prevBtn.frame = CGRectMake(0, cellHeight, cellWidth, topLabelHeight);
        [prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //Next Button 
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
        nextBtn.frame = CGRectMake(calendarWidth-cellWidth, cellHeight, cellWidth, topLabelHeight);
        [nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //Top Labbel
        CGRect monthLabelFrame = CGRectMake(cellWidth, cellHeight, calendarWidth-cellWidth*2, topLabelHeight);
        monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
        monthLabel.font = [UIFont fontWithName:calendarFontname size:18];
        monthLabel.textAlignment = UITextAlignmentCenter;
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.textColor = [UIColor blackColor];
        
        //Add the calendar header to view
        [self addSubview:prevBtn];
        [self addSubview:nextBtn];
        [self addSubview:monthLabel];
        
        //add the day labels to the view
//        NSString *days[7] ={@"月",@"火",@"水",@"木",@"金",@"土",@"日"};
        for (int i = 0; i<7; i++) {
            CGRect dayLabelFrame = CGRectMake(cellWidth*i, logoHeight + topLabelHeight, cellWidth, cellHeight);
            UILabel *dayLabelBase = [[UILabel alloc] initWithFrame:dayLabelFrame];
            

            dayLabel[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"syuu%d.png",i]]];
            dayLabel[i].bounds = CGRectMake(0 , 0 , 12, 12);
//            NSLog(@"%@",NSStringFromCGRect(dayLabel[i].frame));
            [dayLabelBase addSubview:dayLabel[i]];
//            [dayLabel[i] release];
//            }
            [self addSubview:dayLabelBase];
        }
        CGPoint MonCenterPoint = CGPointMake(22, 21);
        dayLabel[0].center = MonCenterPoint;
        CGPoint SunCenterPoint = CGPointMake(22, 21);
        dayLabel[6].center = SunCenterPoint;
        int syuu = [[NSUserDefaults standardUserDefaults] integerForKey:@"syuu_preference"];
        switch (syuu) {
            case 0:
                [self syuu_preference:0];
                break;
                
            case 1:
                [self syuu_preference:1];
                break;
                
            default:
                break;
        }
       
        
        [self drawDayButtons];
        
        //Set the current month and year and update the calendar
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSUInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit;
        NSDateComponents *dataParts = [calendar components:unitFlags fromDate:[NSDate date]];
        
        currentMonth =[dataParts month];
        currentYear = [dataParts year];
        
        [self updateCalendarForMonth:currentMonth forYear:currentYear];
        
        
        //スワイプについて
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(prevBtnPressed:)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeGestureRight];
            
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextBtnPressed:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeGestureLeft];
        
        //右下の予定について
        scdBtn = [[UILabel alloc] init];
        initFrm = CGRectMake(cellWidth*0 + 13,logoHeight + topLabelHeight + 6*cellHeight - 10, 320 - cellWidth -13, cellHeight+10);
        scdBtn.frame = initFrm;
        scdBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        CALayer *layer = [scdBtn layer];
        layer.cornerRadius = 6;
        scdBtn.minimumFontSize = 13;
        scdBtn.numberOfLines = 3;
        [self addSubview:scdBtn];
        
        //vacationFlag
        vacationFlag = 0;

    }
    return self;
}

- (void)updateCalendarForMonth:(int)month forYear:(int)year{
    char *months[12] = {"January","February","March","April","May","June","July","August","September","October","November","December"};
    monthLabel.text = [NSString stringWithFormat:@"%d  %s",year, months[month-1]];
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    [dateParts release];
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
    int weekdayOfFirst = [weekdayComponents weekday];
//    NSLog(@"%d",weekdayOfFirst);
    
    //祝日を決めておく
//    char *holidays[9] = {"01-01","02-11","04-29","05-03","05-04","05-05","11-03","11-23","12-23"};
//    NSString *strHoliday[9];
//    for (int i=0; i<9; i++) {
//        strHoliday[i] = [NSString stringWithFormat:@"%s",holidays[i]];
//    }
    NSDateFormatter *d1;
    d1 = [[[NSDateFormatter alloc] init] autorelease];
    
    NSLog(@"確認:%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"syuu_preference"]);
    int week_pre = [[NSUserDefaults standardUserDefaults] integerForKey:@"syuu_preference"];
    if ( week_pre == 0) {
    
        //weekdayの設定は1は日曜日、２が月曜日と一つずれてるので
        if (weekdayOfFirst == 1) {
            weekdayOfFirst = 7;
        }else{
            --weekdayOfFirst;
        }
        
    }
    
    int numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:dateOnFirst].length;
    
    int day = 1;
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            int buttonNumber = i*7 +j;
            
            DayButton *button = [self.dayButtons objectAtIndex:(buttonNumber)];
            
            button.enabled = NO;
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateHighlighted];
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitle:nil forState:UIControlStateNormal];
            [button setButtonDate:nil];
            
            if (buttonNumber >= (weekdayOfFirst-1) && day <= numDaysInMonth ) {
                [button setTitle:[NSString stringWithFormat:@"%d",(day)] forState:UIControlStateNormal];
                NSDateComponents *dateParts = [[NSDateComponents alloc] init];
                [dateParts setYear:year];
                [dateParts setMonth:month];
                [dateParts setDay:day];
                NSDate *buttonDate = [calendar dateFromComponents:dateParts];
                [dateParts release];
                [button setButtonDate:buttonDate];
                
                button.enabled = YES;
                ++day;
                
                //今日の色の変更
                NSDateFormatter *d2;
                d2 = [[[NSDateFormatter alloc] init] autorelease];
                d1.dateFormat = @"yyyy-MM-dd";
                d2.dateFormat = @"yyyy-MM-dd";
                NSString *s1,*s2;
                s1 = [d1 stringFromDate:button.buttonDate];
                s2 = [d2 stringFromDate:[NSDate date]];
                
                if ([s1 isEqualToString:s2]) {
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

//                    button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
//                    CALayer *layer = button.layer;
//                    layer.cornerRadius = 6;
                    
                    //ボタンの画像セット
                    // リサイズ例文（サイズを指定する方法）
//                    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    UIImage *img_mae = [UIImage imageNamed:@"grey.png"];  // リサイズ前UIImage
                    [button setBackgroundImage:img_mae forState:UIControlStateNormal];
                    [button setBackgroundImage:img_mae forState:UIControlStateHighlighted];                    
                    
                    [button setTodayColor];



                }else {
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    button.backgroundColor = [UIColor whiteColor];
//                    [button setBackgroundImage:nil forState:UIControlStateNormal];
//                    [button setBackgroundImage:nil forState:UIControlStateHighlighted];
//                    [button setImage:nil forState:UIControlStateNormal];
                    [button returnColor];
                }
                
//                //日曜祝日は赤くする
//                //日曜
//                if (buttonNumber%7 == 6) {
//                    button.titleLabel.textColor = [UIColor redColor];
//                }
            }

            switch (week_pre) {
                case 0://月曜が週の最初
                    //日曜
                    if (buttonNumber%7 == 6) {
                        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    }
                    
                    //土曜(青)
                    if (vacationFlag == 0) {
                        
                    
                    if (buttonNumber%7 == 5) {
                        UIColor *satColor = [UIColor colorWithRed:0.08 green:0.0 blue:0.88 alpha:1.0];
                        [button setTitleColor:satColor forState:UIControlStateNormal];
                    }
                    }else {
                        [self setRedButton:button];
                    }
                    
//                    //曜日の設定
//                    [self syuu_preference:0];
                    break;
                    
                case 1://日曜が週の最初
                    //日曜
                    if (buttonNumber%7 == 0) {
                        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    }
                    
                    //土曜(青)
                    if (vacationFlag == 0) {
                        
                        
                        if (buttonNumber%7 == 6) {
                            UIColor *satColor = [UIColor colorWithRed:0.08 green:0.0 blue:0.88 alpha:1.0];
                            [button setTitleColor:satColor forState:UIControlStateNormal];
                        }
                    }else {
                        [self setRedButton:button];
                    } 
                    
//                    //曜日の設定
//                    [self syuu_preference:1];
                    break;
                    
                    
                default:
                    break;
            }
            
            
            
            //祝日
            [self setRedHoliday:button day:day j:j];
            

            //学校行事
            [self setSchoolEvent:button];
            
//          9月は赤
//            NSDateFormatter *d3 = [[[NSDateFormatter alloc] init] autorelease];
//            d3.dateFormat = @"yyyy-MM";
//            //            NSLog(@"datef:%@ date:%@",[d3 stringFromDate:button.buttonDate], button.buttonDate);
//            if ([[d3 stringFromDate:button.buttonDate] isEqualToString:@"2012-09"]) {
//                [self setRedButton:button];
//            }
            
            
        }
    }
    
    initFrm = CGRectMake(cellWidth*0 + 13,logoHeight + topLabelHeight + 6*cellHeight - 9, 320 -24, cellHeight+7);
    scdBtn.frame = initFrm;
    
    //週の始めのフラグ
    int syuu = [[NSUserDefaults standardUserDefaults] integerForKey:@"syuu_preference"];
    
    //行事Labelをきめる
    if (year == 2012) {
        
        switch (month) {
            case 3:
                scdBtn.text = @"";
                break;
                
            case 4:
                scdBtn.text = @" 5日 入学式\n 6日 春学期開講 \n 春学期履修登録期間(4/6〜4/19)";
                switch (syuu) {
                    case 0:
                        
                        initFrm = CGRectMake(cellWidth*1 + 13,logoHeight + topLabelHeight + 6*cellHeight - 9, 320- cellWidth*1 -26, cellHeight+7);
                        scdBtn.frame = initFrm; 
                        break;

                    default:
                        break;
                }
                
                break;
                
            case 5:
                scdBtn.text = @" 25日 清陵祭準備日\n 26〜27日 清陵祭\n 履修キャンセル期間(5/18〜5/24)";
                break;
                
            case 6:
                scdBtn.text = @" 1日 開学記念日(授業日)";
                break;
                
            case 7:
                scdBtn.text = @" 17日 授業振替日\n   　 (月曜日の授業を行う)\n 春学期末試験期間(30~)";
                switch (syuu) {
                    case 0:
                        initFrm = CGRectMake(cellWidth*2 + 13,logoHeight + topLabelHeight + 6*cellHeight - 9, 320- cellWidth*1 -26, cellHeight+7);
                        scdBtn.frame = initFrm; 
                        break;
                        
                    default:
                        break;
                }
                
                break;
                
            case 8:
                scdBtn.text = @" 〜3日 春学期期末試験期間\n 夏季休業期間(8/4〜9/30)";
                break;
                
            case 9:
                scdBtn.text = @" 夏季休業期間(~9/30)";
                switch (syuu) {
                    case 1:
                        initFrm = [self setLocationAndWidth:1];
                        scdBtn.frame = initFrm; 
                        break;
                        
                    default:
                        break;
                }
                break;
                
            case 10:
                scdBtn.text = @" 1日 秋学期開講    4日 入学式(秋季)\n 27日 ホームカミングデー\n 履修登録期間(10/1〜10/15)";
                break;
                
            case 11:
                scdBtn.minimumFontSize = 10;
                scdBtn.text = @"1日 常盤祭準備日  2〜4日 常盤祭\n21日 授業振替日(金曜日の授業を行う)\n 履修キャンセル期間(11/12〜11/16)";
                break;
                
            case 12:
                scdBtn.text = @" 冬季休業期間(12/24〜1/6)";
                switch (syuu) {
                    case 1:
                        initFrm = CGRectMake(cellWidth*2 + 13,logoHeight + topLabelHeight + 6*cellHeight - 9, 320- cellWidth*2 -26, cellHeight+7);
                        scdBtn.frame = initFrm; 
                        break;
                        
                    default:
                        break;
                }
                break;
                
            default:
                scdBtn.text = @"";
                break;
        }
    }
    
    if (year == 2013) {
        switch (month) {
            case 1:
                scdBtn.text = @"冬季休業期間(〜1/6)\n15日 授業振替日(金曜日の授業を行う)\n18~21日 大学入試センター試験休業日";
                break;
                
            case 2:
                scdBtn.text = @" 5日 英語統一テスト試験日\n 6〜13日 秋学期末試験期間\n      　　(13日は月曜日の試験を行う)";
                break;
                
            case 3:
                scdBtn.text = @" 22日 卒業式・修了式\n 春季休業期間(〜3/31)";
                switch (syuu) {
                    case 1:
                        initFrm = [self setLocationAndWidth:1];
                        scdBtn.frame = initFrm; 
                        break;
                        
                    default:
                        break;
                }
                break;
                
            default:
                scdBtn.text = @"";
                break;
        }
    }
    
}

- (void)drawDayButtons{
        self.dayButtons = [[NSMutableArray alloc] initWithCapacity:42];
    for (int i = 1; i<7; i++) {
        for (int j = 0; j<7; j++) {
//            CGRect buttonFrame = CGRectMake(j*cellWidth, (i+2)*cellHeight, cellWidth, cellHeight);
            CGRect buttonFrame = CGRectMake(j*cellWidth, logoHeight + topLabelHeight + i*cellHeight - 10, cellWidth, cellHeight);
            DayButton *dayButton = [[DayButton alloc] buttonWithFrame:buttonFrame];
            dayButton.titleLabel.font = [UIFont fontWithName:calendarFontname size:17];
//            dayButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            dayButton.delegate = self;
                        
            [self.dayButtons addObject:dayButton];
            [dayButton release];
            
            [self addSubview:[self.dayButtons lastObject]];
        }
    }

}

- (void)prevBtnPressed:(id)sender{
    if (currentMonth == 1) {
        currentMonth = 12;
        currentYear--;
    }else{
        currentMonth--;
    }
    
    if (currentYear == 2012) {
        if (currentMonth < 4) {
            currentMonth = 4;
        }
    }
    
    [self updateCalendarForMonth:currentMonth forYear:currentYear];
    [self.delegate prevButtonPressed];
    
}

- (void)nextBtnPressed:(id)sender{
    if (currentMonth == 12) {
        currentMonth = 1;
        currentYear++;
    }else{
        currentMonth++;
    }
    
    if (currentYear == 2013) {
        if (currentMonth > 3) {
            currentMonth = 3;
        }
    }
    
    [self updateCalendarForMonth:currentMonth forYear:currentYear];
    [self.delegate nextButtonPressed];
    
}

//Button delegate
- (void)dayButtonPressed:(id)sender{
    DayButton *dayButton = (DayButton *) sender;
    [self.delegate dayButtonPressed:dayButton];
}

- (void)buttonDoubleTap:(id)sender
{
    DayButton *dayButton = (DayButton *)sender;
    [self.delegate dayButtonDoubleTap:dayButton];
}

#pragma mark 週の始めの設定
- (void)syuu_preference:(int)syuu
{
    switch (syuu) {
        case 0:
            for (int i = 0; i<7; i++) {
                
                dayLabel[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"syuu%d.png",i]];
//                CGRect dayLabelFrame = CGRectMake(cellWidth*i, logoHeight + topLabelHeight, cellWidth, cellHeight);
//                UILabel *dayLabelBase = [[UILabel alloc] initWithFrame:dayLabelFrame];
//                
//                
//                dayLabel[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"syuu%d.png",i]]];
//                dayLabel[i].bounds = CGRectMake(0 , 0 , 12, 12);
//                //            NSLog(@"%@",NSStringFromCGRect(dayLabel[i].frame));
//                [dayLabelBase addSubview:dayLabel[i]];
//                [dayLabel[i] release];
//                //            }
//                [self addSubview:dayLabelBase];
            }
//            CGPoint MonCenterPoint = CGPointMake(22, 21);
//            dayLabel[0].center = MonCenterPoint;
//            CGPoint SunCenterPoint = CGPointMake(22, 21);
//            dayLabel[6].center = SunCenterPoint;
            break;
            
        case 1:
            for (int i=0 ; i<7; i++) {
                if (i == 0) {
                    dayLabel[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"syuu6.png"]];
                }else {
                    dayLabel[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"syuu%d.png",i-1]];
                }
                
            }
            break;
        default:
            break;
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

#pragma mark ボタンを赤くする
- (void)setRedButton:(UIButton *)button 
{
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

//祝日
- (void)setRedHoliday:(DayButton *)button day:(int)day j:(int)j
{
    //祝日
//  [self setRedButton:button];
//    }
    
    //休日2020年まで(冬休みを追加)
    NSDateFormatter *d1;
    d1 = [[[NSDateFormatter alloc] init] autorelease];
    d1.dateFormat = @"yyyy-MM-dd";
    char *holidays2[20] = {/*"2011-01-01","2011-01-10","2011-02-11","2011-03-21","2011-04-29","2011-05-03","2011-05-04",
        "2011-05-05","2011-07-18","2011-09-19","2011-09-23","2011-10-10","2011-11-03","2011-11-23","2011-12-23",
        "2012-01-01","2012-01-02","2012-01-09","2012-02-11",*/
        "2012-03-20","2012-04-29","2012-04-30","2012-05-03",
        "2012-05-04","2012-05-05","2012-07-16","2012-09-17",
        "2012-09-22","2012-10-08","2012-11-03","2012-11-23",
        "2012-12-23","2012-12-24","2013-01-01","2013-01-14",
        "2013-02-11","2013-03-20",
        //冬休み
//        "2013-01-02","2013-01-03","2013-01-04","2013-01-05","2013-01-06",
        "2012-11-02","2012-05-26"
        /*,"2013-04-29","2013-05-03",
        "2013-05-04","2013-05-05","2013-05-06","2013-07-15","2013-09-16","2013-09-23","2013-10-14","2013-11-03",
        "2013-11-04","2013-11-23","2013-12-23","2014-01-01","2014-01-13","2014-02-11","2014-03-21","2014-04-29",
//        "2014-05-03","2014-05-04","2014-05-05","2014-05-06","2014-07-21","2014-09-15","2014-09-23","2014-10-13",
//        "2014-11-03","2014-11-23","2014-11-24","2014-12-23","2015-01-01","2015-01-12","2015-02-11","2015-03-21",
//        "2015-04-29","2015-05-03","2015-05-04","2015-05-05","2015-05-06","2015-07-20","2015-09-21","2015-09-22",
//        "2015-09-23","2015-10-12","2015-11-03","2015-11-23","2015-12-23","2016-01-01","2016-01-11","2016-02-11",
//        "2016-03-20","2016-03-21","2016-04-29","2016-05-03","2016-05-04","2016-05-05","2016-07-18","2016-09-19",
//        "2016-09-22","2016-10-10","2016-11-03","2016-11-23","2016-12-23","2017-01-01","2017-01-02","2017-01-09",
//        "2017-02-11","2017-03-20","2017-04-29","2017-05-03","2017-05-04","2017-05-05","2017-07-17","2017-09-18",
//        "2017-09-23","2017-10-09","2017-11-03","2017-11-23","2017-12-23","2018-01-01","2018-01-08","2018-02-11",
//        "2018-02-12","2018-03-21","2018-04-29","2018-04-30","2018-05-03","2018-05-04","2018-05-05","2018-07-16",
//        "2018-09-17","2018-09-23","2018-09-24","2018-10-08","2018-11-03","2018-11-23","2018-12-23","2018-12-24",
//        "2019-01-01","2019-01-14","2019-02-11","2019-03-21","2019-04-29","2019-05-03","2019-05-04","2019-05-05",
//        "2019-05-06","2019-07-15","2019-09-16","2019-09-23","2019-10-14","2019-11-03","2019-11-04","2019-11-23",
//        "2019-12-23","2020-01-01","2020-01-13","2020-02-11","2020-03-20","2020-04-29","2020-05-03","2020-05-04",
//        "2020-05-05","2020-05-06","2020-07-20","2020-09-21","2020-09-22","2020-10-12","2020-11-03","2020-11-23",
//        "2020-12-23","2021-01-01","2021-01-11","2021-02-11","2021-03-20","2021-04-29","2021-05-03","2021-05-04",
//        "2021-05-05","2021-07-19","2021-09-20","2021-09-23","2021-10-11","2021-11-03","2021-11-23","2021-12-23"*/
    };
//    NSString *strHoliday2[20];
//    for (int i=0; i<20; i++) {
//        strHoliday2[i] = [NSString stringWithFormat:@"%s",holidays2[i]];
//    }
//    for (int i=0; i<20; i++) {
//        if ([strHoliday2[i] isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
//            [self setRedButton:button];
//        }
//    }  
    
    //赤くする日(改)
    for (int i=0; i<20; i++) {
        [self compareDateAndSetRed:holidays2[i] dateformatter:d1 daybutton:button];
    }
}

//赤くする日(NSStrinをいちいち作らない)
- (void)compareDateAndSetRed:(char *)date dateformatter:(NSDateFormatter *)df daybutton:(DayButton *)button
{
    NSString *strRed;
    strRed = [NSString stringWithFormat:@"%s",date];
    if ([strRed isEqualToString:[df stringFromDate:button.buttonDate]]){
        [self setRedButton:button];
    }
}

//学校行事
- (void)setSchoolEvent:(DayButton *)button
{
    //入学式
    NSString *strEnrolment, *strTermSpring, *strSeiryousaiPrepare, *strSeiryousai[2],
                *strEstablish, *strSpringExam[5], *strSummerVacation,
                *strTermAutmn, *strFallEnrolment, *strTokiwaFestivalPrepare,
                *strTokiwaFes[3], *strWinterVaction, *strCenterExam,
                *strCenterExam_2 , *strCenterExam_3,
                *strEnglishExam, *strAutmnExam[5],//*strSpringVacation,
                *strGraduation,*strHomeComing;
    NSString *hurikae[3];
    
    strEnrolment = [NSString stringWithFormat:@"2012-04-05"];
    strTermSpring = [NSString stringWithFormat:@"2012-04-06"];
    strSeiryousaiPrepare = [NSString stringWithFormat:@"2012-05-25"];
    strSeiryousai[0] = [NSString stringWithFormat:@"2012-05-26"];
    strSeiryousai[1] = [NSString stringWithFormat:@"2012-05-27"];
    strEstablish = [NSString stringWithFormat:@"2012-06-01"];
    strSpringExam[0] = [NSString stringWithFormat:@"2012-07-30"];
    strSpringExam[1] = [NSString stringWithFormat:@"2012-07-31"];
    strSpringExam[2] = [NSString stringWithFormat:@"2012-08-01"];
    strSpringExam[3] = [NSString stringWithFormat:@"2012-08-02"];
    strSpringExam[4] = [NSString stringWithFormat:@"2012-08-03"];
    strSummerVacation = [NSString stringWithFormat:@"2012-08-04"];
    strTermAutmn = [NSString stringWithFormat:@"2012-10-01"];
    strFallEnrolment = [NSString stringWithFormat:@"2012-10-04"];
    strTokiwaFestivalPrepare = [NSString stringWithFormat:@"2012-11-01"];
    strTokiwaFes[0] = [NSString stringWithFormat:@"2012-11-02"];
    strTokiwaFes[1] = [NSString stringWithFormat:@"2012-11-03"];
    strTokiwaFes[2] = [NSString stringWithFormat:@"2012-11-04"];
    strWinterVaction = [NSString stringWithFormat:@"2012-12-24"];
    strCenterExam = [NSString stringWithFormat:@"2013-01-18"];
    strCenterExam_2 = [NSString stringWithFormat:@"2013-01-19"];
    strCenterExam_3 = [NSString stringWithFormat:@"2013-01-20"];
    strEnglishExam = [NSString stringWithFormat:@"2013-02-05"];
    strAutmnExam[0] = [NSString stringWithFormat:@"2013-02-06"];
    strAutmnExam[1] = [NSString stringWithFormat:@"2013-02-07"];
    strAutmnExam[2] = [NSString stringWithFormat:@"2013-02-08"];
    strAutmnExam[3] = [NSString stringWithFormat:@"2013-02-12"];
    strAutmnExam[4] = [NSString stringWithFormat:@"2013-02-13"];
//    strSpringVacation = [NSString stringWithFormat:@"2013-02-14"];
    strGraduation = [NSString stringWithFormat:@"2013-03-22"];
    strHomeComing = [NSString stringWithFormat:@"2012-10-27"];
    
    hurikae[0] = [NSString stringWithFormat:@"2012-07-17"];
    hurikae[1] = [NSString stringWithFormat:@"2012-11-21"];
    hurikae[2] = [NSString stringWithFormat:@"2013-01-15"];
    
    NSDateFormatter *d1;
    d1 = [[[NSDateFormatter alloc] init] autorelease];
    d1.dateFormat = @"yyyy-MM-dd";
    
    //入学式
    if ([strEnrolment isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
//        [button setBackgroundImage :[UIImage imageNamed:@"sakura.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"sakura5.png"] forState:UIControlStateNormal];
//        UILabel *lbl = [[UILabel alloc] init];
//        lbl.backgroundColor = [UIColor blueColor];
    }//else {
//        [button setImage:nil forState:UIControlStateNormal];
//    }
    
    //春学期開始
    if ([strTermSpring isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"dango6.png"] forState:UIControlStateNormal];
    }
    
    //清陵祭準備日
    if ([strSeiryousaiPrepare isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"midori25.png"] forState:UIControlStateNormal];
        [self setRedButton:button];
    }
    
    //星陵祭
    for (int i=0; i<2; i++) {
        if ([strSeiryousai[i] isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
            if(i == 0){
            [button setImage :[UIImage imageNamed:@"sei1.png"] forState:UIControlStateNormal];
            }else  {
                [button setImage:[UIImage imageNamed:@"sei2.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    //開学記念日
    if ([strEstablish isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"kaigaku.png"] forState:UIControlStateNormal];
//        [self setRedButton:button];
    }
    
    //春期末試験
    for (int i=0; i<5; i++) {
        if ([strSpringExam[i] isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
            if(i == 0){
            [button setImage :[UIImage imageNamed:@"test30.png"] forState:UIControlStateNormal];
            }else if (i == 1) {
                [button setImage :[UIImage imageNamed:@"test31.png"] forState:UIControlStateNormal];
            }else if (i == 2) {
                [button setImage :[UIImage imageNamed:@"test1.png"] forState:UIControlStateNormal];
            }else if (i == 3) {
                [button setImage :[UIImage imageNamed:@"test2.png"] forState:UIControlStateNormal];
            }else if (i == 4) {
                [button setImage :[UIImage imageNamed:@"test3.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    //夏期休業開始
    if ([strSummerVacation isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setBackgroundImage :[UIImage imageNamed:@"suica4.png"] forState:UIControlStateNormal];
    }
    
    //秋学期開始
    if ([strTermAutmn isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"momiji1.png"] forState:UIControlStateNormal];
    }
    
    //秋入学
    if ([strFallEnrolment isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"ittyou4.png"] forState:UIControlStateNormal];
    }
    
    //ホームカミングデー
    if ([strHomeComing isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"midori27.png"] forState:UIControlStateNormal];
    }
    
    //常盤祭準備
    if ([strTokiwaFestivalPrepare isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"midori1.png"] forState:UIControlStateNormal];
        [self setRedButton:button];
    }
    
    //常盤祭
    for (int i=0; i<3; i++) {
        if ([strTokiwaFes[i] isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
            if(i==0){
            [button setImage :[UIImage imageNamed:@"tokiwa2.png"] forState:UIControlStateNormal];
            }else if (i==1) {
                [button setImage:[UIImage imageNamed:@"tokiwa3.png"] forState:UIControlStateNormal];
            }else {
                [button setImage:[UIImage imageNamed:@"tokiwa4.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    //冬季休業期間
    if ([strWinterVaction isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"winVac24.png"] forState:UIControlStateNormal];
    }
    
    //センター試験
    if ([strCenterExam isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"midori18.png"] forState:UIControlStateNormal];
        [self setRedButton:button];
    }
    if ([strCenterExam_2 isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"midori19.png"] forState:UIControlStateNormal];
    }
    if ([strCenterExam_3 isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"midori20.png"] forState:UIControlStateNormal];
        [self setRedButton:button];
    }
    
    //英語統一テスト試験
    if ([strEnglishExam isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage :[UIImage imageNamed:@"orange5.png"] forState:UIControlStateNormal];
    }
    
    //秋季期末
    for (int i=0; i<5; i++) {
        if ([strAutmnExam[i] isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
            if(i==0){
            [button setImage:[UIImage imageNamed:@"test6.png"] forState:UIControlStateNormal];
            }else if (i==1) {
                [button setImage:[UIImage imageNamed:@"test7.png"] forState:UIControlStateNormal];
            }else if (i==2) {
                [button setImage:[UIImage imageNamed:@"test8.png"] forState:UIControlStateNormal];
            }else if (i==3) {
                [button setImage:[UIImage imageNamed:@"test12.png"] forState:UIControlStateNormal];
            }else if (i==4) {
                [button setImage:[UIImage imageNamed:@"test13.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    
    
    //卒業式
    if ([strGraduation isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
        [button setImage:[UIImage imageNamed:@"black22.png"] forState:UIControlStateNormal];
    }
    
    //振替授業
    for (int i=0; i<3; i++) {
        if ([hurikae[i] isEqualToString:[d1 stringFromDate:button.buttonDate]]) {
            if(i == 0){
            [button setImage:[UIImage imageNamed:@"huri17.png"] forState:UIControlStateNormal];
            }else if (i==1) {
                [button setImage:[UIImage imageNamed:@"huri21.png"] forState:UIControlStateNormal];
            }
            else {
                [button setImage:[UIImage imageNamed:@"huri15.png"] forState:UIControlStateNormal];
            }
        }
    }

}

- (void)insertTodayInformation:(int)month todayYear:(int)year
{
    currentMonth = month;
    currentYear = year;
}

- (CGRect)setLocationAndWidth:(int)num
{
    switch (num) {
        case 0:
            return initFrm;
            break;
            
        case 1:
            initFrm = CGRectMake(cellWidth*1 + 13,logoHeight + topLabelHeight + 6*cellHeight - 9, 320- cellWidth*1 -26, cellHeight+7);
            return initFrm;
            
        case 2:
            initFrm = CGRectMake(cellWidth*2 + 13,logoHeight + topLabelHeight + 6*cellHeight - 9, 320- cellWidth*2 -26, cellHeight+7);
            return initFrm;
            
        default:
            break;
    }
    
    return CGRectZero;
}

- (void)dealloc{
    [super dealloc];
    [calendar release];
    [_dayButtons release];
    for (int i; i<7; i++) {
        [dayLabel[i] release];
    }
}

@end
