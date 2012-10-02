//
//  AppDelegate.m
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/22.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize memoTableViewController = __memoTableViewController;
@synthesize undoManager = _undoManager;
@synthesize fetchedResultsController = _fetchedResultsController;
//@synthesize memoVc = __memoVc;

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [__memoTableViewController release];
    [_undoManager release];
//    [__memoVc release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初期設定
    [self setting];
    
    
    // Override point for customization after application launch.
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //MemoTableViewController
//    __memoTableViewController = [[MemoTableViewController alloc] init];
//    __memoTableViewController.managedObjectContext = self.managedObjectContext;
    
    //MainViewController
    viewController = [[MainViewController alloc] init];
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
    defaultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading2.png"]];
    [self.window addSubview:defaultView];
    [self fadeView];
    
//    //NSUserDefaultのデフォルト値を決定
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    //今日重要なメモがあれば通知
    [defaults setObject:@"0" forKey:@"TodayLocalPush"];
    //表示範囲(UISegmentControll)
    [defaults setObject:@"1" forKey:@"PredicateSetting"];
    //Local通知の時間
    // 文字列から日時を生成する
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [formatter dateFromString:@"7:00"];
//    NSLog(@"Date: %@", date);
    [defaults setObject:date  forKey:@"NotifyTime"];
//    [defaults setObject:@"0" forKey:@"BeginningView"];
    
    //重要メモがないときの促し
    [defaults setObject:@"0" forKey:@"ImpView"];
    
    //週のはじめの設定
    [defaults setObject:@"0" forKey:@"syuu_preference"];
    
    [ud registerDefaults:defaults];
    
    return YES;
}

- (void)fadeView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
//    [UIView setAnimationDelay:1.0];
    defaultView.alpha = 0.0;
    [UIView commitAnimations];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    [viewController getToday];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    _fetchedResultsController = nil;
//    NSLog(@"backGround");
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"TodayLocalPush"] == 0) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
//        NSLog(@"Cancel");
    }else {
//        ImportantViewController *impvc = [[[ImportantViewController alloc] init] autorelease];
//        [impvc setLocalNotification:2];
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
            if ([[[calendar dateFromComponents:finalDatecom] laterDate:[NSDate date]] isEqualToDate:[calendar dateFromComponents:finalDatecom]]) {
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            }
            
        }
        // 解放
        [notification release];
        
        // アラート通知をキャンセルする(重複通知対策)
        for (UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSInteger keyId = [[notify.userInfo objectForKey:@"NOTIF_KEY"] intValue];
            
            if (keyId == 1) {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
            }
        }
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
//    [viewController getToday];
    [self performSelector:@selector(gt) withObject:nil afterDelay:0.1];
    
    //起動時画面の設定をしていたら遷移
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"BeginningView"] == 1) {
//        [viewController ToImpView];
//    }
}

- (void)gt{
    [viewController getToday];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    if(notification) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Info"
//                              message:@"Alert No.2"
//                              delegate:self
//                              cancelButtonTitle:@"OK" 
//                              otherButtonTitles:nil];
//        [alert show];
//    }
    [viewController ToImpView];
}





- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"memocale3" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"memocale3.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Action" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    //検索条件の設定 
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    if ([df integerForKey:@"PredicateSetting"] == 0) {
        
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
        
//    }else{
//        
//        //重要なメモ全て
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scrOrMemo == 1"];
//        [fetchRequest setPredicate:predicate];
//    }
    
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"] autorelease];
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@",error, [error userInfo]);
        abort();
    }
    
    
     
    return _fetchedResultsController;
    
}

#pragma mark 設定
- (void)setting{
    //NSUserDefaultのデフォルト値を決定
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    //今日重要なメモがあれば通知
    [defaults setObject:@"0" forKey:@"TodayLocalPush"];
    //表示範囲(UISegmentControll)
    [defaults setObject:@"1" forKey:@"PredicateSetting"];
    //Local通知の時間
    // 文字列から日時を生成する
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [formatter dateFromString:@"7:00"];
    //    NSLog(@"Date: %@", date);
    [defaults setObject:date  forKey:@"NotifyTime"];
    //    [defaults setObject:@"0" forKey:@"BeginningView"];
    
    //重要メモがないときの促し
    [defaults setObject:@"0" forKey:@"ImpView"];
    
    //週のはじめの設定
    [defaults setObject:@"0" forKey:@"syuu_preference"];
//    NSLog(@"%@",[defaults objectForKey:@"syuu_preference"]);
    [ud registerDefaults:defaults];
}
@end
