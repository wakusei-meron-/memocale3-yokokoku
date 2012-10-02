//
//  Action.h
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/19.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Action : NSManagedObject

@property (nonatomic, retain) NSNumber * backColor;
@property (nonatomic, retain) NSNumber * charColor;
@property (nonatomic, retain) NSString * memoText;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * scrOrMemo;

@end
