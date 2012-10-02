//
//  ImportantSettingViewController.m
//  memocale3-yokokoku
//
//  Created by 石橋 弦樹 on 12/04/24.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import "ImportantSettingViewController.h"
//#import <MessageUI/MessageUI.h>
//#import <MessageUI/MFMailComposeViewController.h>


@interface ImportantSettingViewController ()

@end

@implementation ImportantSettingViewController

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSUserDefaultのデフォルト値を決定
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
//    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
//        //今日重要なメモがあれば通知
//    [defaults setObject:@"0" forKey:@"TodayLocalPush"];
//        //表示範囲(UISegmentControll)
//    [defaults setObject:@"0" forKey:@"PredicateSetting"];
//        //起動時の画面
//    [defaults setObject:@"0" forKey:@"BeginningView"];
//        
//    [ud registerDefaults:defaults];
        
    //今日重要なメモによってrowの数変更
    if ([ud integerForKey:@"TodayLocalPush"] == 0) {
        rowNum1 = 1;
    }else {
        rowNum1 = 2;
    }
    //UISwitchの代入
    cell1_switch.on = [ud integerForKey:@"TodayLocalPush"];
    
    //UISegmentControllの代入
    cell2_segmt.selectedSegmentIndex = [ud integerForKey:@"PredicateSetting"];
    
    //UISwitchの代入(cell3:起動時の画面)
    cell3_switch.on = [ud integerForKey:@"BeginningView"];
    
    
    
}

- (void)viewDidUnload
{
    [cell1 release];
    cell1 = nil;
    [cell1_switch release];
    cell1_switch = nil;
    [cell2 release];
    cell2 = nil;
    [cell2_segmt release];
    cell2_segmt = nil;
    [cell3 release];
    cell3 = nil;
    [cell3_switch release];
    cell3_switch = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return rowNum1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

//sectionの名前
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"通知設定";
            break;
            
        case 1:
            return @"重要なメモの表示";
            break;
            
        case 2:
            return @"ご意見・ご要望";
            break;

            
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        switch (indexPath.section) {
            case 0:
            
                switch (indexPath.row) {
                    case 0:
                        cell = cell1;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        break;
                        
                    case 1:
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
                        cell.textLabel.text = @"通知時間";
                        NSDate *notifyTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotifyTime"];
                        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
                        df.dateFormat = @"H:mm";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:notifyTime]];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        break;
                    default:
//                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
                        break;
                }
                
                break;
                
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell = cell2;
                        break;
                        
                    default:
                        break;
                }
                break;
                
            case 2:
                switch (indexPath.row) {
                    case 0:
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.textLabel.text = @"メールを送る";
                        break;
                        
                    default:
                        break;
                }
                break;
            default:
//                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                break;
        }
//    } 
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    DateViewController *dvc = [[[DateViewController alloc] initWithNibName:@"DateViewController" bundle:nil] autorelease];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    //
                    
                    
                    
//                    NSLog(@"date is the %@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"NotifyTime"] description]);
                    [self.navigationController pushViewController:dvc animated:YES];
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
//        case 2:
//            switch (indexPath.row) {
//                case 0://メールを送る
//                    mailPicelr = [[MFMailComposeViewController alloc] init];
//                    mailPicelr.delegate = self;
//                    [mailPicelr setToRecipients:[NSArray arrayWithObject:@"aiueo@google.com"]];
//                    [mailPicelr setTitle:@"Title"];
//                    [self.navigationController presentModalViewController:mailPicelr animated:YES];
////                    [mailPicelr release];
//                    break;
//                    
//                default:
//                    break;
//            }
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [cell1 release];
    [cell1_switch release];
    [cell2 release];
    [cell2_segmt release];
    [cell3 release];
    [cell3_switch release];
    [super dealloc];
}

#pragma mark 設定の処理
- (IBAction)cell1_swt:(id)sender {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setInteger:cell1_switch.on forKey:@"TodayLocalPush"];
    if (cell1_switch.on == 0) {
        rowNum1 =  1;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }else {
        rowNum1 = 2;
//        // ローカル通知を作成する
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        
//        // 通知日時を設定する。今から10秒後
//        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5];
//        [notification setFireDate:date];
//        
//        // タイムゾーンを指定する
//        [notification setTimeZone:[NSTimeZone localTimeZone]];
//        
//        // メッセージを設定する
//        [notification setAlertBody:@"でたー！！"];
//        
//        // 効果音は標準の効果音を利用する
//        [notification setSoundName:UILocalNotificationDefaultSoundName];
//        
//        // ボタンの設定
//        [notification setAlertAction:@"Open"];
//        
//        // ローカル通知を登録する
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        
//        // 解放
//        [notification release];
//        NSLog(@"通知完了");
        
    }
    [self callDelegate];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

}

- (void)callDelegate{
    
    [self.delegate setLocalNotification:rowNum1];
}

- (IBAction)cell2_sgmt:(UISegmentedControl *)sender {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setInteger:sender.selectedSegmentIndex forKey:@"PredicateSetting"];
    
    //変更を伝達(デリゲート)
    [self.delegate changePredicate];
}

- (IBAction)cell3_swt:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.on forKey:@"BeginningView"];
}

#pragma mark メール送るデリゲート
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"ありがとう");
}
@end
