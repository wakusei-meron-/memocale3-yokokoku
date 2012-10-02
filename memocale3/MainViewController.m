//
//  MainViewController.m
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/23.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
//        scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height/2.0)];
        
        view = [[UIView alloc] init];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
//    //NSUserDefaultのデフォルト値を決定
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
//    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
//        //今日重要なメモがあれば通知
//    [defaults setObject:@"0" forKey:@"TodayLocalPush"];
//        //表示範囲(UISegmentControll)
//    [defaults setObject:@"1" forKey:@"PredicateSetting"];
//        //起動時の画面
//    [defaults setObject:@"0" forKey:@"BeginningView"];
//    
//    [ud registerDefaults:defaults];
    
    
    UIView *appView =[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
//    callendarView_year = [[CallendarView_year alloc] initWithFrame:appView.bounds fontName:@"AmericanTypewriter" delegate:self];
    callendarView_year = [[CallendarView_year alloc] initWithFrame:appView.bounds fontName:@"Verdana" delegate:self];//@"eurostile" delegate:self];
//    NSLog(@"%@",NSStringFromCGSize(appView.bounds.size));
    appView.backgroundColor = [UIColor whiteColor];
    self.view = appView;
    
    [self.view addSubview:callendarView_year];
    
    
    //フリックについて
//    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector()];
//    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeGestureRight];
//    
//    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(prevButtonPressed)];
}

//トップボタン
- (void)conform
{
//    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
//    appDelegate.memoTableViewController.managedObjectContext = appDelegate.managedObjectContext;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:appDelegate.memoTableViewController];
//    [nav setNavigationBarHidden:NO];
//    [self.view addSubview:nav.view];

    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //タブバー
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
    toolBar.barStyle = UIBarStyleBlack;
    
    //タブバーボタン
    //週ボタン
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"週" style:UIBarButtonItemStyleBordered target:self action:@selector(conform)];
    //ロゴボタン(右)
    UIBarButtonItem *btn_logo = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"e.png"] style:UIBarButtonItemStylePlain target:self action:@selector(staffView)] autorelease];
    
    //ロゴボタン(左)
    UIImageView *logo_img = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"memocal.png"]] autorelease];
    
    //設定ボタン
//    UIBarButtonItem *btn_setting = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    //スペース
    UIBarButtonItem *btn_space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
   
    //重要ボタン
    UIBarButtonItem *btn_Imp = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bikkuri.png"] style:UIBarButtonItemStylePlain target:self action:@selector(ToImpView)] autorelease];
    
    //可変スペース
    UIBarButtonItem *btn_canSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    btn_canSpace.width = logo_img.image.size.width;
    
    //右側ボタン
//    UIBarButtonItem *btn_mail = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mail.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sendMail)] autorelease];

    
//    NSArray *items =[NSArray arrayWithObjects: btn_space, btn_logo, btn_space, nil];
    NSArray *items = [NSArray arrayWithObjects:btn_Imp, btn_canSpace,btn_logo, btn_space, nil];
    toolBar.items = items;
    
    CGPoint logo_img_center = CGPointMake(toolBar.bounds.size.width/2.0 - 18 , logo_img.center.y - 5);
    logo_img.center = logo_img_center;
    [toolBar addSubview:logo_img];
//    [toolBar setBackgroundImage:[UIImage imageNamed:@"up_banner.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:toolBar];
    [toolBar release];
//    NSLog(@"TopBar size %@",NSStringFromCGSize(toolBar.bounds.size));
    
}

//メールを送る
- (void)sendMail
{

    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    vc.mailComposeDelegate = self;
    [vc setToRecipients:[NSArray arrayWithObject:@"ynu.memocale@gmail.com"]];
    vc.title = @"Title";
    vc.navigationBar.tintColor = [UIColor blackColor];
    [vc setSubject:@"ご意見・要望"];
    [self presentModalViewController:vc animated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    //起動時画面の設定をしていたら遷移
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"BeginningView"] == 1) {
//        [self ToImpView];
//    }
//}

#pragma mark - 追加
- (void)dayButtonPressed:(DayButton *)button{
    
    //AppDelegate
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //画面遷移(MemoView)
    memoVc = [[MemoViewController alloc] init];
    memoVc.date = button.buttonDate;//日付代入
    memoVc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    memoVc.delegate = self;
    [self presentModalViewController:memoVc animated:YES];
    
    
    //変更
//    [scrView addSubview:memoVc.scrView];
//    memoVc.scrView.scrollEnabled = NO;
//    scrView.canCancelContentTouches = YES;
//    scrView.delaysContentTouches = YES;
//    scrView.contentSize = CGSizeMake(memoVc.view.bounds.size.width, 800);
//    [memoVc load_data];
//    [self.view addSubview:scrView];
    

    
}

- (void)nextButtonPressed{
    [self MemoDidChangeContent];
}

- (void)prevButtonPressed{
    
    [self MemoDidChangeContent];
}

- (void)getToday
{
    
    //曜日のイメージを変える
    int syuu = [[NSUserDefaults standardUserDefaults] integerForKey:@"syuu_preference"];
    switch (syuu) {
        case 0:
            [callendarView_year syuu_preference:0];
            break;
            
        case 1:
            [callendarView_year syuu_preference:1];
            break;
            
        default:
            break;
    }
    
    //Set the current month and year and update the calendar
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    NSUInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit;
    NSDateComponents *dataParts = [calendar components:unitFlags fromDate:[NSDate date]];
    [callendarView_year updateCalendarForMonth:[dataParts month] forYear:[dataParts year]];
    [callendarView_year insertTodayInformation:[dataParts month] todayYear:[dataParts year]];
    
}

- (void)dayButtonDoubleTap:(DayButton *)button
{
    [self dayButtonPressed:button];
    [memoVc plus_memo];
}

- (void)staffView
{
//    staffView = [[[StaffView alloc] initWithFrame:self.view.bounds] autorelease];
//    [self.view addSubview:staffView];
//    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeStaffView)] autorelease];
//    [tapGesture setNumberOfTapsRequired:1];
//    [staffView addGestureRecognizer:tapGesture];
    setvc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    setvc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:setvc animated:YES];
//    [setvc release];
}

- (void)ToImpView
{
    ImportantViewController *impvc = [[[ImportantViewController alloc] initWithNibName:@"ImportantViewController" bundle:nil] autorelease];
    
    impvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self  presentModalViewController:impvc animated:YES];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:impvc] autorelease];
    nav.navigationBar.tintColor = [UIColor blackColor];
    
//    //設定ボタン
//    UIBarButtonItem *btn_config = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config.png"] style:UIBarButtonItemStylePlain target:self action:nil];
//    
//    nav.navigationItem.rightBarButtonItem = btn_config;
    
//    [nav setNavigationBarHidden:NO];
    
    [self presentModalViewController:nav animated:YES];


}

#pragma mark MemoViewControllerDelegate
- (void)MemoDidChangeContent
{
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            int buttonNumber = i*7 + j;
            [[callendarView_year.dayButtons objectAtIndex:buttonNumber] layoutSubviews];
//            [[callendarView_year.dayButtons objectAtIndex:buttonNumber] sarch_num];
        }
    }
    

}

- (void)ImpDidChange
{
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            int buttonNumber = i*7 + j;
//            [[callendarView_year.dayButtons objectAtIndex:buttonNumber] layoutSubviews];
            [[callendarView_year.dayButtons objectAtIndex:buttonNumber] sarch_num];
        }
    }
}

- (void)dealloc{
    [super dealloc];
}

- (void)predictImp
{
     
}

#pragma mark メール関連
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            //メールを送信した時
            NSLog(@"送信");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信完了" 
                                                            message:@"ご意見・ご要望\nありがとうございました。\n"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"保存");
            break;
            
        case MFMailComposeResultCancelled:
            NSLog(@"キャンセル");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"失敗");
            alert.title = @"送信失敗";
            alert.message = @"送信できませんでした。\n電波の良いところでもう一度送信していただけるようお願いします。";
            [alert show];
            break;
            
        default:
            break;
    }

    [self dismissModalViewControllerAnimated:YES];
}

@end
