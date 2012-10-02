//
//  ImportantViewController.h
//  memocale3-yokokoku
//
//  Created by 石橋 弦樹 on 12/04/24.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "ImportantSettingViewController.h"
#import "MemoViewController2.h"
#import "Action.h"

@interface ImportantViewController : UITableViewController<NSFetchedResultsControllerDelegate,ImportantSVCDelegate,MemoViewControllerDelegate2,
                                                UIActionSheetDelegate>
{
    
    Action *selectedAction;

}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)setLocalNotification:(int)OneOffTwoOn;

@end
