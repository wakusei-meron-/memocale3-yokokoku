//
//  MemoScrolView.h
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/19.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemoScrolViewDelegate;

@interface MemoScrolView : UIScrollView
{
    UILabel *strTime[18];
    UILabel *strFree;
    
}

@property (nonatomic, retain)UIImageView *imgView;
@property (nonatomic, assign)id<MemoScrolViewDelegate> delegate2;



//- (void)drawLine;
- (void)setString;
- (void)deleteSchedule;

@end


@protocol MemoScrolViewDelegate <NSObject>

- (void)doubleTap;
- (void)oneTap;

@end
