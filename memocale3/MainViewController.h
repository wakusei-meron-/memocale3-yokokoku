//
//  MainViewController.h
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/23.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CallendarView_year.h"
#import "MemoViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "ImportantViewController.h"

@interface MainViewController : UIViewController<CalendarViewDelegate,MemoViewControllerDelegate,
                                                    NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    CallendarView_year *callendarView_year;
    MemoViewController *memoVc;
//    UIScrollView *scrView;
    UIView *view;
    
    SettingViewController *setvc;
    
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

#pragma mark あとで消す
- (void)conform;
- (void)getToday;
- (void)ToImpView;

@end
