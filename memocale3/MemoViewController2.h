//
//  MemoViewController2.h
//  memocale3-yokokoku
//
//  Created by 石橋 弦樹 on 12/04/27.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoViewController.h"

@protocol MemoViewControllerDelegate2;

@interface MemoViewController2 : MemoViewController

@property (nonatomic, retain)id<MemoViewControllerDelegate2> delegate2;

@end

@protocol MemoViewControllerDelegate2 <NSObject>

- (void)change;

@end
