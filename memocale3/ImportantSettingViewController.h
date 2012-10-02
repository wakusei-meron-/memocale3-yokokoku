//
//  ImportantSettingViewController.h
//  memocale3-yokokoku
//
//  Created by 石橋 弦樹 on 12/04/24.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DateViewController.h"

@protocol ImportantSVCDelegate;

@interface ImportantSettingViewController : UITableViewController<MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    int rowNum1;
    
    
    IBOutlet UITableViewCell *cell1;
    IBOutlet UISwitch *cell1_switch;
    IBOutlet UITableViewCell *cell2;
    IBOutlet UISegmentedControl *cell2_segmt;
    IBOutlet UITableViewCell *cell3;
    IBOutlet UISwitch *cell3_switch;
    
    MFMailComposeViewController *mailPicelr;
    
//    id <ImportantSVCDelegate> delegate;
}

@property (nonatomic, assign)id<ImportantSVCDelegate> delegate;

- (IBAction)cell1_swt:(id)sender;
- (IBAction)cell2_sgmt:(UISegmentedControl *)sender;
- (IBAction)cell3_swt:(UISwitch *)sender;
- (void)callDelegate;
@end

@protocol ImportantSVCDelegate <NSObject>

- (void)changePredicate;
- (void)setLocalNotification:(int)OneOffTwoOn;

@end
