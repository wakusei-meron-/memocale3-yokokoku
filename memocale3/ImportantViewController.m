//
//  ImportantViewController.m
//  memocale3-yokokoku
//
//  Created by 石橋 弦樹 on 12/04/24.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import "ImportantViewController.h"

#import "MemoTableViewController.h"
#import "MemoViewController2.h"

@interface ImportantViewController ()

@end

@implementation ImportantViewController

@synthesize fetchedResultsController = _fetchedResultsController;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"重要なメモ";
        CGRect tb_rect = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
        self.tableView.frame = tb_rect;
        
        //ナビゲーションバー
        //設定ボタン
        UIBarButtonItem *btn_config = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pushConfigButton)] autorelease];
        self.navigationItem.rightBarButtonItem = btn_config;
        

        UIBarButtonItem *btn_left = [[[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStylePlain target:self action:@selector(backCalendar)] autorelease];
        self.navigationItem.leftBarButtonItem = btn_left;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
//    [cell1 release];
//    cell1 = nil;
//    [cell1_switch release];
//    cell1_switch = nil;
//    [tableViewSetting release];
//    tableViewSetting = nil;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        
//        NSError *error = nil;
//        if (![context save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
        
//        [self.tableView reloadData];
        [self deleteImpMemo:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"重要リストから削除";
}


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
    
    //セルをタッチするとその日に行くか、重要リストから消すか
    //actionの取得
    selectedAction = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //actionSheetで選択できるようにする
    UIActionSheet *aSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"選択した日の編集をする", @"重要リストから削除する", nil] autorelease];
    [aSheet showInView:self.view];
    
    //その日に行く
//    MemoViewController2 *memovc = [[MemoViewController2 alloc] init];
//    memovc.date = action.timeStamp;
//    memovc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    memovc.delegate2 = self;
//    [self presentModalViewController:memovc animated:YES];
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Action" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    //検索条件の設定 
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if ([df integerForKey:@"PredicateSetting"] == 0) {
        
        //複数条件(今日以降の重要メモ)
        NSMutableArray *array = [NSMutableArray array];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"scrOrMemo == 1"];
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        df.dateFormat = @"yyyy-MM-dd";
        
        //今日以降の条件模索中
        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        NSUInteger unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
        NSDateComponents *dateParts = [calendar components:unitFlag fromDate:[NSDate date]];
        dateParts.hour = 0;
        NSDate *setDate = [calendar dateFromComponents:dateParts];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"timeStamp >= %@",setDate] ;
        [array addObject:predicate1];
        [array addObject:predicate2];
        
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:array];
        [fetchRequest setPredicate:predicate];
    }else{
        
        //重要なメモ全て
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scrOrMemo == 1"];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES] autorelease];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSSortDescriptor *sortDescriptor2 = [[[NSSortDescriptor alloc] initWithKey:@"y" ascending:YES] autorelease];//y順(時間順)
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, sortDescriptor2, nil];

    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"] autorelease];
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@",error, [error userInfo]);
        abort();
    }
    

    //一回だけ表示
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ImpView"] == 0){
    if ( [self tableView:self.tableView numberOfRowsInSection:0] == 0) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"メモから重要ボタンを押して下さい" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PredicateSetting"] == 0) {
            alert.message = @"今日以降のメモから\n重要ボタンを押して下さい";
        }
        [alert show];
    }
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ImpView"];
    }
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    } 
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"memoText"];
//    cell.detailTextLabel.text = [[object valueForKey:@"timeStamp"] description];
    cell.imageView.image = [UIImage imageNamed:@"bikkuri.png"];
    
    //曜日を取得
    NSString *week = [NSString stringWithString:[self stringShotweekday:[object valueForKey:@"timeStamp"]]];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"mode"] == 0) {
        NSDateFormatter *df = [[[NSDateFormatter alloc] init]autorelease];
       df.dateFormat = @"M月d日";
        NSMutableString *mStr = [NSMutableString stringWithFormat:[df stringFromDate:[object valueForKey:@"timeStamp"]]]; 
        float pointY = [[object valueForKey:@"y"] floatValue];
        
        //30分単位で分ける
        int judgeNum = floorf((pointY - (60-22.5+22.5/2.0))/22.5);
        
        //偶数と奇数で分ける
        int devNum = judgeNum%2;
        
        //時間に直す
        judgeNum = judgeNum/2.0;
        
        //週を追加する
        [mStr appendString:[NSString stringWithFormat:@"(%@)",week]];
        
        if (judgeNum>=0){
        switch (devNum) {
            case 0:
               [mStr appendString:[NSString stringWithFormat:@" %d:30頃",judgeNum+6-1]]; 
                break;
               
            case 1:
                [mStr appendString:[NSString stringWithFormat:@" %d:00頃",judgeNum+6]];
                break;
                
            default:
                break;
        }
        }
        
        
        
        cell.detailTextLabel.text = mStr;
                                 
        
    }else{
       NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        df.dateFormat = @"M月d日"; 
        NSMutableString *str_date = [NSMutableString stringWithString:[df stringFromDate:[object valueForKey:@"timeStamp"]]];
        [str_date appendString:[NSString stringWithFormat:@"(%@)",week]];
        cell.detailTextLabel.text = str_date;
    }
}

//intをNSStringに変換
- (NSString *)intToNSString:(int)intNum
{
    NSString *str = [NSString stringWithFormat:@"%d",intNum];
    
    return str;
}

#pragma mark ボタンが押された時のアクション
- (void)pushConfigButton
{
    ImportantSettingViewController *impvc = [[[ImportantSettingViewController alloc] initWithNibName:@"ImportantSettingViewController" bundle:nil] autorelease];
    impvc.delegate = self;
    [self.navigationController pushViewController:impvc animated:YES];
}
                                     
- (void)backCalendar
{
    [self dismissModalViewControllerAnimated:YES];
}

//セッティングボタン
- (void)pushSettingButton
{
    ImportantSettingViewController *impvc = [[[ImportantSettingViewController alloc] initWithNibName:@"ImportantSettingViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:impvc animated:YES];
}

#pragma mark 週を得るための関数
//週を数で取得
- (NSInteger)weekday:(NSDate *)date
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    return comps.weekday;
}

//文字列で返す
- (NSString *)stringShotweekday:(NSDate *)date
{
    static NSString *const array[] = {nil, @"日",@"月",@"火",@"水",@"木",@"金",@"土"};
    NSInteger index = [self weekday:date];
    if (index > 7) index = 0;
    
    return array[index];
}

#pragma mark ImportantSVCDelegate

- (void)changePredicate
{
    _fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void)setLocalNotification:(int)OneOffTwoOn
{
    if (OneOffTwoOn == 1) {
        
    }else{
    // ローカル通知を作成する
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // タイムゾーンを指定する
    [notification setTimeZone:[NSTimeZone localTimeZone]];
        
    // メッセージを設定する
    [notification setAlertBody:@"今日は重要な予定があります"];
        
    // 効果音は標準の効果音を利用する
    [notification setSoundName:UILocalNotificationDefaultSoundName];
        
    // ボタンの設定
    [notification setAlertAction:@"確認する"];
    
        NSLog(@"objectNumber:%d",[[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]);
        
    for (int i=0; i<[[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]; i++) {
        
        //通知内容を設定
//        NSString *memo = [NSString stringWithFormat:@"%@", [[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] memoText]];
//        [notification setAlertBody:memo];

        // 通知日時を設定する。
        //日にちと時間を入れるための準備
        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        NSUInteger unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        //最終的な日にちのコンポーネント
        NSDateComponents *finalDatecom = [[[NSDateComponents alloc] init] autorelease];
    
        //日にちの設定
        NSDateComponents *dateParts = [calendar components:unitFlag fromDate:[[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] timeStamp]];
    
        //日にち代入
        finalDatecom.year = dateParts.year;
        finalDatecom.month = dateParts.month;
        finalDatecom.day = dateParts.day;
    
        //時間の設定
        NSDateComponents *hourParts = [calendar components:unitFlag fromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"NotifyTime"]];
    
        //時間を代入
        finalDatecom.hour = hourParts.hour;
        finalDatecom.minute = hourParts.minute;
        
//        finalDatecom.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JST"];
        
        //組み合わせたNSDate作成
//        NSDate *finalDate = [[NSDate alloc] init];
//        finalDate = finalDatecom.date;
    
        [notification setFireDate:[calendar dateFromComponents:finalDatecom]];
        
        // ローカル通知を登録する
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }
    // 解放
    [notification release];
    NSLog(@"通知完了");
    
    // アラート通知をキャンセルする(重複通知対策)
    for (UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSInteger keyId = [[notify.userInfo objectForKey:@"NOTIF_KEY"] intValue];
        
        if (keyId == 1) {
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
        }
    }
    }
}

#pragma mark バタンを押した時の処理

//選択したところに行く
- (void)goMemoViewController:(Action *)action
{
    MemoViewController2 *memovc = [[[MemoViewController2 alloc] init] autorelease];
    memovc.date = action.timeStamp;
    memovc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    memovc.delegate2 = self;
    [self presentModalViewController:memovc animated:YES];
 
}

//重要リストから消す
- (void)deleteImpMemo:(Action *)action
{
    action.scrOrMemo = 0;
    
    //保存
    NSError *error = nil;
    [action.managedObjectContext save:&error];
    
    //更新できるように
    _fetchedResultsController = nil;
    
    //リロード
    [self.tableView reloadData];
}


#pragma mark MemoViewController2 Delegate


-  (void)change
{
    _fetchedResultsController = nil;
    [self.tableView reloadData];

}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //actionの取得
//    Action *action = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    switch (buttonIndex) {
        case 0:
            [self goMemoViewController:selectedAction];
            break;
            
        case 1:
            [self deleteImpMemo:selectedAction];
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
//    [cell1 release];
//    [cell1_switch release];
//    [tableViewSetting release];
    [super dealloc];
}
@end
