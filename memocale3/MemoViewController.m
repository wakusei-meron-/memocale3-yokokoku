//
//  MemoViewController.m
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/24.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import "MemoViewController.h"

#import "Action.h"
//#import "imobileAds/IMAdView.h"


@implementation MemoViewController
@synthesize date=date, delegate = _delegate;
@synthesize doubleTapGesture = _doubleTapGesture;
@synthesize scrView = _scrView;


//@synthesize fetchedResultsController = __fetchedResultsController;
//@synthesize managedObjectContext = __managedObjectContext;

#define newMemo 0
#define changeMemo 1

////色について
//#define brack 0
//#define RED 1
//#define orange 2
//#define yellow 3
//#define GREEN 4
//#define cyan 5
//#define BLUE 6
//#define purple 7
//
////メモの色について
//#define pWhite 0
//#define pRed 1
//#define pOrenge 2
//#define pYellow 3
//#define pGreen 4
//#define pCyan 5
//#define pBlue 6
//#define pPurple 7
//色について
#define BLACK 0
#define RED 1
#define BLUE 2
#define GREEN 3

//メモの色について
#define PWHITE 0
#define PYELLOW 1
#define PORANGE 2
#define PRED 3
#define PPINK 4
#define PPURPLE 5
#define PBLUE 6
#define PCYAN 7
#define PBLUEGREEN 8
#define PGREEN 9
#define PSUNGREEN 10
#define PBRAWN 11

#define ScrollViewMode 0
#define MemoViewMode 1


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //Property背景(View)
//        UIColor *backpatternImage = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"square-paper.png"]] autorelease];
//        self.view.backgroundColor = backpatternImage;
//        CGRect viewBack_rect = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height);
//        viewBack = [[UIView alloc] initWithFrame:viewBack_rect];
//        viewBack.backgroundColor = backpatternImage;
//        [self.view addSubview:viewBack];
        
        //scrViewに
        CGRect scrView_rect = CGRectMake(0.0, 44, self.view.bounds.size.width, 366);
        self.scrView = [[[MemoScrolView alloc] initWithFrame:scrView_rect] autorelease];
        self.scrView.delegate2 = self;
        [self.view addSubview:self.scrView];
        
//        scrView.canCancelContentTouches = NO;
//        scrView.delaysContentTouches = NO;
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


#define publisherID 8438
#define mediaID 20826
#define spotID 37980
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //タップで反応するように設定
    //ダブルタップ
    self.doubleTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewDoubleTap:)] autorelease];
    [self.doubleTapGesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:self.doubleTapGesture];
//    [_doubleTapGesture release];
//    doubleTapGesture.enabled = NO;
    [self initialize];
//    [self load_data];
    
    //ワンタップ
//    UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearDeleteBtn)];
//    [oneTapGesture setNumberOfTapsRequired:1];
//    [ addGestureRecognizer:oneTapGesture];
    
    //広告が映らなかった時の背景
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ynu_logo.png"]];
    img.frame = CGRectMake(0, self.view.frame.size.height-50, 320, 50);
    [self.view addSubview:img];
    [img release];
    
    //広告
//    CGRect frame = CGRectMake(0.0, self.view.frame.size.height-kIMAdViewDefaultHeight, kIMAdViewDefaultWidth, kIMAdViewDefaultHeight);
//    IMAdView *imAdView = [[IMAdView alloc] initWithFrame:frame
//                                             publisherId:publisherID 
//                                                 mediaId:mediaID
//                                                  spotId:spotID
//                                                ];
//    [self.view addSubview:imAdView];
//    [imAdView release];
}

//メモではなくViewをダブルタップ
- (void)ViewDoubleTap:(UITapGestureRecognizer *)tapGesture
{
    tapGesture.enabled = NO;
    [self disappearDeleteBtn];
    doubleTapPoint = [tapGesture locationInView:nil];
//    NSLog(@"%@",NSStringFromCGPoint(doubleTapPoint));
    [self createInputView_kai:nil];
    [viewInput_kai cancelOrDelete:0];
//    tapGesture.enabled = NO;
    isNew = changeMemo;
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    
//    NSLog(@"%@",[date description]);
    
    //ToolBar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
    toolBar.barStyle = UIBarStyleBlack;
    
    //BarButtonItem
    UIBarButtonItem *btn_back = [[[UIBarButtonItem alloc] 
                                 initWithTitle:@"戻る" 
                                 style:UIBarButtonItemStyleBordered 
                                 target:self
                                 action:@selector(backCalendar_year)] 
                                 autorelease];
    UIBarButtonItem *btn_plus = [[[UIBarButtonItem alloc] 
                                 initWithImage:[UIImage imageNamed:@"edit.png"] 
                                 style:UIBarButtonItemStylePlain 
                                 target:self action:@selector(plus_memo)]
                                 autorelease];//SystemItemAdd target:nil action:@selector(plus_memo)];
    btn_plus.width += 50;
    UIBarButtonItem *btn_TimeSchedule = [[[UIBarButtonItem alloc]
                                         initWithImage:[UIImage imageNamed:@"clock.png"] 
                                         style:UIBarButtonItemStylePlain
                                         target:self 
                                         action:@selector(scrModeChange)] 
                                         autorelease];
    UIBarButtonItem *btnSpace = [[[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                 target:nil action:nil] autorelease];
    

    //date
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    df.dateFormat = @"yyyy年M月d日";
    NSString *string_date = [df stringFromDate:date];
    float string_width = 130;
    float string_height = 30;
    UILabel *lbl_date = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, string_width, string_height)] autorelease];
    lbl_date.textAlignment = UITextAlignmentCenter;
    lbl_date.backgroundColor = [UIColor clearColor];
    lbl_date.textColor = [UIColor whiteColor];
    lbl_date.text = string_date;
    
    //UIViewをUIImageに変換
    UIImage *screenImage;
    
    UIGraphicsBeginImageContext(lbl_date.frame.size);
    [lbl_date.layer renderInContext:UIGraphicsGetCurrentContext()];
    screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIBarButtonItem *bbi_date = [[[UIBarButtonItem alloc] 
                                 initWithImage:screenImage 
                                 style:UIBarButtonItemStylePlain 
                                 target:self 
                                 action:@selector(backCalendar_year)] 
                                 autorelease];
//    UIButton *bbi_date = [UIButton buttonWithType:UIButtonTypeCustom];
//    bbi_date.frame = lbl_date.frame;
//    [bbi_date setImage:screenImage forState:UIControlStateNormal];
//    UIBarButtonItem *bbi_date = [[UIBarButtonItem alloc] initWithCustomView:lbl_date];
    bbi_date.width = string_width;    
    
    NSArray *items =[NSArray arrayWithObjects:bbi_date, btn_plus,btn_TimeSchedule, btnSpace, btn_back, nil];
    toolBar.items = items;
    [self.view addSubview:toolBar];
    [toolBar release];

    
    
    [self load_data];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    //Frame
//    float width = 300;
//    float height = 207;
//    CGRect viewInput_rect = CGRectMake((self.view.frame.size.width - width)/2.0, 0, width, height);
//    
//    viewInput_kai = [[InputView alloc] initWithFrame:viewInput_rect];// autorelease];
//    viewInput_kai.txf.delegate = self;
//    viewInput_kai.delegate = self;
//    [viewInput_kai retain];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate ImpDidChange];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - ボタン関連
//戻る
- (void)backCalendar_year{
    
    [self dismissModalViewControllerAnimated:YES];

    [self saveCondition];
}

//Undo
- (void)scrModeChange{

    alartScd = [[UIAlertView alloc] initWithTitle:@"確認" 
                                          message:@"スケジュールモードに\n変更してもよろしいでしょうか？" 
                                         delegate:self 
                                cancelButtonTitle:@"Cancel" 
                                otherButtonTitles:@"OK", nil];
    [alartScd show];
//    [self setScrViewToolBarItems];
//    [self.view addSubview:scrView];
//    scrMode = YES;

} 

//プラスボタン
- (void)plus_memo
{
    //デリートモード解除
    [self disappearDeleteBtn];
    
    //入力ビュー生成
//    [self createInputView:nil];
    [self createInputView_kai:nil];
    
    //newかchangeか
    new_or_chage = newMemo;
    
    //ダブルタッチ
    self.doubleTapGesture.enabled = NO;
    
    [viewInput_kai cancelOrDelete:0];
}

//タイムスケジュールのボタン
- (void)backMemo
{
    alartMemo = [[UIAlertView alloc] initWithTitle:@"確認"
                                 message:@"メモモードに変更しても\nよろしいでしょうか？\n\n(メモの位置が変わる事があります)" delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"OK", nil];
    [alartMemo show];
    
//    [scrBar removeFromSuperview];
//    [scrView removeFromSuperview];
//    scrMode = NO;
}


#pragma mark UITextFieldデリゲート
// UIテキストフィールドデリゲート
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //[textField resignFirstResponder];
    
    switch (new_or_chage) {
        case newMemo:
            //新しいメモの追加・保存
            [self createNewObject:textField.text];
            break;
            
        case changeMemo:
            //メモ内容の変更
            [self changeObject:textField.text memoView:selectView_change];
            break;
        default:
            break;
    }
    
    
    //入力ビューの削除
    [self delete_memoView];
    
    //ダプルタップの解除
    self.doubleTapGesture.enabled = YES;
    
    //色をデフォルトに戻す
//    selectCharColor = 0;
//    selectMemoColor = 0;
    
    //初期化
    [self initialize];
    return YES;
}

#pragma mark - 繰り返しメソッド

//入力ビューの削除
- (void)delete_memoView{
//    [view_Input removeFromSuperview];
    [viewInput_kai removeFromSuperview];
//    self.fetchedResultsController = nil;
    //    view_Input = nil;
    //    txf_memo = nil;
    //    [view_Input release];
    //    [txf_memo release];
    
    
}

//新しいメモの追加・保存
- (void)createNewObject:(NSString *)memo
{
    //appDelegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //それぞれ生成
    Action *aAction = (Action *)[NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:appDelegate.managedObjectContext];
    if (aAction == nil) {
        NSLog(@"しっぱい");
    }
    
    //属性をセット
    aAction.memoText = memo;
    aAction.timeStamp = date;
    aAction.charColor = [NSNumber numberWithInteger:selectCharColor];
    aAction.backColor = [NSNumber numberWithInteger:selectMemoColor];
    //scrOrMemoは重要かどうか
    aAction.scrOrMemo = [NSNumber numberWithInteger:selectImp];
    aAction.x = [NSNumber numberWithFloat:doubleTapPoint.x];
    float y = doubleTapPoint.y + self.scrView.contentOffset.y -64;
    if (y < 0) {
        y =15;
    }else if(y>810) {
        y=810;
    }

    aAction.y = [NSNumber numberWithFloat:y];
    
//    NSLog(@"%@",aAction);
    if (isNew == newMemo) {
        aAction.y = [NSNumber numberWithFloat:(self.scrView.contentOffset.y + 200)];
    }
//    if (scrMode) {
//        aAction.scrOrMemo = [NSNumber numberWithInt:ScrollViewMode];
//    }else {
//        aAction.scrOrMemo = [NSNumber numberWithInt:MemoViewMode];
//    }
    
    //変更をコミット
    NSError *error = nil;
    if (![aAction.managedObjectContext save:&error]) {
        NSLog(@"error %@ %@",error,[error userInfo]);
    }
    //変更を伝達
    [self.delegate MemoDidChangeContent];
    
    //IDをひとつ増やす
    MemoID_ViewController++;
    
    //メモの配置
    [self arrange_memo:aAction];
}

//DBからデータの読み出し
- (void)load_data
{
    //appDelegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //データベースから読み取るリクエスト作成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] autorelease];
    
    //取得するエンティティを設定
    NSEntityDescription *entityDescription;
    entityDescription = [NSEntityDescription entityForName:@"Action" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entityDescription];

    
    //ソート条件配列を作成
    NSSortDescriptor *desc;
    desc = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES] autorelease];
    
    NSArray *sortDescriptor = [[[NSArray alloc] initWithObjects:desc, nil] autorelease];
    [fetchRequest setSortDescriptors:sortDescriptor];
    
    //取得条件の設定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp == %@",date];
    [fetchRequest setPredicate:predicate];
    
    //取得最大数の設定
    [fetchRequest setFetchBatchSize:20];
    
    //データ取得用コントローラを作成
    NSFetchedResultsController *resurutsController;
    resurutsController = [[[NSFetchedResultsController alloc]
                           initWithFetchRequest:fetchRequest
                           managedObjectContext:appDelegate.managedObjectContext
                           sectionNameKeyPath:nil
                           cacheName:@"Action"] autorelease];

    
    //DBから値の取得
    NSError *error = nil;
    if (![resurutsController performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
    }
    
    //取得結果をNSArrayに代入
    NSArray *result = [resurutsController fetchedObjects];
    
    //それぞれの要素をActionに代入して,メモの描画
    for (MemoID_ViewController =0; MemoID_ViewController<[result count]; MemoID_ViewController++) {
        action[MemoID_ViewController] = [result objectAtIndex:MemoID_ViewController];
        [self arrange_memo:action[MemoID_ViewController]];
    }
    
    //初期配置
    [self initialPosition];
    
}

////メモの描画
- (void)arrange_memo:(Action *)receivedAction
{
    //receivedActionからそれぞれ数値を読み取る
    float x,y;
    x = [receivedAction.x floatValue];
    y = [receivedAction.y floatValue];
    int charColor = [receivedAction.charColor intValue];
    int MemoColor = [receivedAction.backColor intValue];
    
    NSString *memoText = receivedAction.memoText;
    
    //大きさの設定(横)
    float memoWidth = [memoText length] * 20;
    if (memoWidth < 80) {
        memoWidth = 80;
    }
    
    //データを代入
    CGRect memo_rect = CGRectMake(x, y, memoWidth, 30);
    put_memoView[MemoID_ViewController] = [[MemoView alloc] initWithFrame:memo_rect];
    put_memoView[MemoID_ViewController].center = CGPointMake(x, y);
    put_memoView[MemoID_ViewController].lbl_memo.text = memoText;
    put_memoView[MemoID_ViewController].action = receivedAction;
    [put_memoView[MemoID_ViewController] setMemoId:MemoID_ViewController];
    
    //重要かどうか判定
    [put_memoView[MemoID_ViewController] checkImp];
    
    //色について
    put_memoView[MemoID_ViewController].lbl_memo.textColor = [self savedCharColor:charColor];
    put_memoView[MemoID_ViewController].lbl_memo.backgroundColor = [self savedMemoColor:MemoColor];
    
    //重要かどうかについて
//    put_memoView[MemoID_ViewController].lbl_memo
    
    //scrViewかどうかで場合分け
//    if (scrMode) {
        
        [self.scrView addSubview:put_memoView[MemoID_ViewController]];
        
//    }else{
        
//    [viewBack addSubview:put_memoView[MemoID_ViewController]];
//        
//    }
    //メモビューのデリゲート宣言
//    newMemoView.delegate = self;
    put_memoView[MemoID_ViewController].delegate = self;
    
    
}


//InputViewの生成・改！！
- (void)createInputView_kai:(MemoView *)prepareView
{
//    //Frame
    float width = 300;
    float height = 207;
    CGRect viewInput_rect = CGRectMake((self.view.frame.size.width - width)/2.0, 0, width, height);
    
    viewInput_kai = [[[InputView alloc] initWithFrame:viewInput_rect] autorelease];
    viewInput_kai.txf.delegate = self;
    viewInput_kai.delegate = self;
    [viewInput_kai setCurrentColorAndImp:selectCharColor back:selectMemoColor ImpOr:selectImp];
    //画面に追加
    [self.view addSubview:viewInput_kai];
    
//    [viewInput_kai setCurrentColor:selectCharColor back:selectMemoColor];
    
    //editModeの変更・ダブルタップをOff
//    doubleTapGesture.enabled = NO;
    
}

//メモ内容の変更
- (void)changeObject:(NSString *)memo memoView:(MemoView *)changedView//action:(Action *)changedAction
{
    //変更Actionの生成・データの代入
    Action *changeAction = changedView.action;
    changeAction.memoText = memo;
    changeAction.charColor = [NSNumber numberWithInteger:selectCharColor];
    changeAction.backColor = [NSNumber numberWithInteger:selectMemoColor];
    changeAction.scrOrMemo = [NSNumber numberWithInteger:selectImp];
    float x,y;
    x = [changedView.action.x floatValue];
    y = [changedView.action.y floatValue];
    
//    selectView_change.action.memoText = memo;
//    selectView_change
    
    
    //保存
    NSError *error = nil;
    if (![changeAction.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
    }
    
    //現在のMemoViewのテキスト・色・サイズの変更・重要か
    put_memoView[selectedId].lbl_memo.text = memo;
    put_memoView[selectedId].lbl_memo.textColor = [self savedCharColor:selectCharColor];
    put_memoView[selectedId].lbl_memo.backgroundColor = [self savedMemoColor:selectMemoColor];
    [put_memoView[selectedId] checkImp];
//    //テキストフィールドに色を入れる
//    viewInput_kai.txf.textColor = [self savedCharColor:selectCharColor];
//    viewInput_kai.txf.backgroundColor = [self savedMemoColor:selectMemoColor];
    
    //メモのサイズについて
    //大きさの設定(横)
    float memoWidth = [memo length] * 20;
    if (memoWidth < 80) {
        memoWidth = 80;
    }
    CGRect memo_rect = CGRectMake(0, 0, memoWidth, 30);
    [put_memoView[[changedView getMemoId]] setFrame:memo_rect];
    put_memoView[[changedView getMemoId]].center = CGPointMake(x, y);
    [changedView lblResize];
}


//undo
- (void)undoRegist{
    
    //appDelegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
//    [[undoManager prepareWithInvocationTarget:self] deleteMemo];
//    NSUndoManager *undoManager_1 = [self undoManager];
//    NSUndoManager *undoManager_2 = appDelegate.managedObjectContext.undoManager;
    
    //登録
//    [[self.undoManager prepareWithInvocationTarget:self] deleteMemo_kai];
    [[appDelegate.managedObjectContext.undoManager prepareWithInvocationTarget:appDelegate.managedObjectContext] deleteMemo_kai];
//    [[put_memoView[selectedId].undoManager prepareWithInvocationTarget:self] deleteMemo_kai];
    
}

//deleteMemo-kai
- (void)deleteMemo_kai
{
    if (selectView_change.action){
        //画面からメモの削除
        [self removeFromSuperviewGraduation:put_memoView[selectedId]];
//        [put_memoView[selectedId] removeFromSuperview];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self 
                                       selector:@selector(removeMemo:)
                                       userInfo:[NSDictionary dictionaryWithObject:put_memoView[selectedId] forKey:@"key"]
                                        repeats:NO];
        
        //消したメモにNULL代入
        put_memoView[selectedId] = NULL;
        
        //選択されたActionの生成
        Action *deleteAction = selectView_change.action;
        
        //appDelegate
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        //DBから削除
        [appDelegate.managedObjectContext deleteObject:deleteAction];
        
        //保存
        NSError *error = nil;
        [appDelegate.managedObjectContext save:&error];
        
        //変更を伝達
        [self.delegate MemoDidChangeContent];
        
        
        
    }
    
    //初期化
[self initialize];

}

//デリートの時小さくなって消えるようにする
- (void)removeFromSuperviewGraduation:(MemoView *)selectMemo
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    selectMemo.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView commitAnimations];
}

//選択されたメモをビューから削除
- (void)removeMemo:(NSTimer *)timer
{
    
    [[timer.userInfo objectForKey:@"key"] removeFromSuperview];
}

- (UIColor *)savedCharColor:(int)colorNum
{
    //文字の色について
//    switch (colorNum) {
//        case brack:
//            return [UIColor blackColor];
//            break;
//            
//        case RED:
//            return [UIColor redColor];
//            break;
//            
//        case orange:
//            return [UIColor orangeColor];
//            break;
//            
//        case yellow:
//            return [UIColor yellowColor];
//            break;
//            
//        case GREEN:
//            return [UIColor greenColor];
//            break;
//            
//        case cyan:
//            return [UIColor cyanColor];
//            break;
//            
//        case BLUE:
//            return [UIColor blueColor];
//            break;
//            
//        case purple:
//            return [UIColor purpleColor];
//            break;
    switch (colorNum) {
        case BLACK:
            return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; 
            break;
            
        case RED:
            return [UIColor colorWithRed:229/255.0 green:6/255.0 blue:21/255.0 alpha:1.0];
            break;
            
        case BLUE:
            return [UIColor colorWithRed:0/255.0 green:58/255.0 blue:169/255.0 alpha:1.0];
            break;
            
        case GREEN:
            return [UIColor colorWithRed:0.0 green:143/255.0 blue:59/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
    return nil;
}

- (UIColor *)savedMemoColor:(int)colorNum
{
    //文字の色について
//    switch (colorNum) {
//        case pWhite:
//            return [UIColor colorWithRed:1.00 green:0.9 blue:0.8 alpha:1.0];
//            break;
//            
//        case pRed:
//            return [UIColor colorWithRed:0.965 green:0.588 blue:0.475 alpha:1.0];
//            break;
//            
//        case pOrenge:
//            return [UIColor colorWithRed:0.976 green:0.678 blue:0.506 alpha:1.0];
//            break;
//            
//        case pYellow:
//            return [UIColor colorWithRed:1.0 green:0.969 blue:0.600 alpha:1.0];
//            break;
//            
//        case pGreen:
//            return [UIColor colorWithRed:0.769 green:0.875 blue:0.608 alpha:1.0];
//            break;
//            
//        case pCyan:
//            return [UIColor colorWithRed:0.427 green:0.812 blue:0.965 alpha:1.0];
//            break;
//            
//        case pBlue:
//            return [UIColor colorWithRed:0.514 green:0.576 blue:0.792 alpha:1.0];
//            break;
//            
//        case pPurple:
//            return [UIColor colorWithRed:0.631 green:0.525 blue:0.749 alpha:1.0];
//            break;
//            
//        default:
//            break;
//    }
    //文字の色について
    switch (colorNum) {
        case PWHITE:
            return [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
            break;
            
        case PYELLOW:
            return [UIColor colorWithRed:1.00 green:249/255.0 blue:159/255.0 alpha:1.0];
            break;
            
        case PORANGE:
            return [UIColor colorWithRed:250/255.0 green:216/255.0 blue:158/255.0 alpha:1.0];
            break;
            
        case PRED:
            return [UIColor colorWithRed:245/255.0 green:162/255.0 blue:167/255.0 alpha:1.0];
            break;
            
        case PPINK:
            return [UIColor colorWithRed:245/255.0 green:180/255.0 blue:207/255.0 alpha:1.0];
            break;
            
        case PPURPLE:
            return [UIColor colorWithRed:210/255.0 green:170/255.0 blue:210/255.0 alpha:1.0];
            break;
            
        case PBLUE:
            return [UIColor colorWithRed:196/255.0 green:170/255.0 blue:210/255.0 alpha:1.0];
            break;
            
        case PCYAN:
            return [UIColor colorWithRed:159/255.0 green:219/255.0 blue:246/255.0 alpha:1.0];
            break;
            
        case PBLUEGREEN:
            return [UIColor colorWithRed:159/255.0 green:221/255.0 blue:216/255.0 alpha:1.0];
            break;
            
        case PGREEN:
            return [UIColor colorWithRed:159/255.0 green:213/255.0 blue:182/255.0 alpha:1.0];
            break;
            
        case PSUNGREEN:
            return [UIColor colorWithRed:212/255.0 green:232/255.0 blue:172/255.0 alpha:1.0];
            break;
            
        case PBRAWN:
            return [UIColor colorWithRed:218/255.0 green:203/255.0 blue:172/255.0 alpha:1.0];
            break;
        default:
            break;
    }
    return nil;                                                 
}

//イニシャライズ
- (void)initialize
{
    new_or_chage = 0;
    selectView_change = NULL;
    selectedId = 0;
    selectCharColor = 0;
    selectMemoColor = 1;
    selectImp = 0;
//    doubleTapGesture = NULL;
    doubleTapPoint = CGPointMake(160, 80);
    isNew = newMemo;
}

//- (void)memoResize:(NSString *)text
//{
//    //大きさの設定(横)
//    float memoWidth = [text length] * 20;
//    if (memoWidth < 80) {
//        memoWidth = 80;
//    }
//}

//バーボタンについて
- (void)setScrViewToolBarItems
{
    //ToolBar
    scrBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
    scrBar.barStyle = UIBarStyleBlack;
    
    //BarButtonItem
    UIBarButtonItem *btn_back = [[[UIBarButtonItem alloc] 
                                 initWithTitle:@"戻る" 
                                 style:UIBarButtonItemStyleBordered 
                                 target:self 
                                 action:@selector(backCalendar_year)]
                                 autorelease];
    UIBarButtonItem *btn_plus = [[[UIBarButtonItem alloc] 
                                 initWithImage:[UIImage imageNamed:@"edit.png"]
                                 style:UIBarButtonItemStylePlain 
                                 target:self action:@selector(plus_memo)] 
                                 autorelease];//SystemItemAdd target:nil action:@selector(plus_memo)];
    btn_plus.width += 50;
    UIBarButtonItem *btn_Memo = [[[UIBarButtonItem alloc] 
                                 initWithImage:[UIImage imageNamed:@"clipboard.png"] 
                                 style:UIBarButtonItemStylePlain
                                 target:self 
                                 action:@selector(backMemo)] 
                                 autorelease];
    UIBarButtonItem *btnSpace = [[[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil]
                                 autorelease];
    
    
    //date
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    df.dateFormat = @"yyyy年M月d日";
    NSString *string_date = [df stringFromDate:date];
    float string_width = 130;
    float string_height = 30;
    UILabel *lbl_date = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, string_width, string_height)] autorelease];
    lbl_date.textAlignment = UITextAlignmentCenter;
    lbl_date.backgroundColor = [UIColor clearColor];
    lbl_date.textColor = [UIColor whiteColor];
    lbl_date.text = string_date;
    
    //UIViewをUIImageに変換
    UIImage *screenImage;
    
    UIGraphicsBeginImageContext(lbl_date.frame.size);
    [lbl_date.layer renderInContext:UIGraphicsGetCurrentContext()];
    screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIBarButtonItem *bbi_date = [[[UIBarButtonItem alloc] 
                                 initWithImage:screenImage
                                 style:UIBarButtonItemStylePlain 
                                 target:self 
                                 action:@selector(backCalendar_year)]
                                 autorelease];
    bbi_date.width = string_width;
    
    
    NSArray *items =[NSArray arrayWithObjects:bbi_date, btn_plus,btn_Memo, btnSpace, btn_back, nil];
    scrBar.items = items;
    [self.view addSubview:scrBar];
}

//状態を保存する
- (void)saveCondition
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    NSString *strMode = [NSString stringWithFormat:@"%smode",[date description]];
//    scrMode = 0;
//    NSLog(@"%d",scrMode);
//    [df setBool:scrMode forKey:[date description]];
    [df setFloat:self.scrView.contentOffset.y forKey:[date description]];
}

//scrかMemoの最初の状態
- (void)initialPosition
{
//    NSString *strMode = [NSString stringWithFormat:@"%smode",[date description]];
    // NSUserDefaultsに初期値を登録する
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:@"1" forKey:@"mode"];
    [defaults setObject:@"0" forKey:[date description]];
    [ud registerDefaults:defaults];
    
    CGPoint contentPoint = CGPointMake(0, [ud floatForKey:[date description]]);
    self.scrView.contentOffset = contentPoint;
     
    //保存したデータを読み込みセットする
    if (ScrollViewMode == [ud integerForKey:@"mode"]) {
        [self setScrViewToolBarItems];
        [self.scrView setString];
    }else{
        self.scrView.contentOffset = CGPointMake(0, 0);
        self.scrView.scrollEnabled = NO;
        [self upMemo];
    }
}

//メモが下にいたら上に持ってくる
- (void)upMemo
{
    for (int i=0; i<=MemoID_ViewController; i++) {
        if (put_memoView[i]) {
            
        
        if (put_memoView[i].frame.origin.y > 350) {
            CGPoint resetPoint = CGPointMake(put_memoView[i].frame.origin.x + put_memoView[i].bounds.size.width/2.0, 200);
            put_memoView[i].center = resetPoint;
            [self moveMemo:resetPoint selectedMemo:put_memoView[i].action];
        }
        }
    }
}

//削除ボタンの非表示
- (void)disappearDeleteBtn
{
    for (int i=0; i<=MemoID_ViewController; i++) {
        if (put_memoView[i]) {
            [put_memoView[i] disappearDeleteBtn];
        }
    }
}

#pragma mark メモビューのデリゲート
- (void)moveMemo:(CGPoint)origin selectedMemo:(Action *)moveAction
{
    //変更Actionの生成・データの代入
    Action *changeAction = moveAction;
    changeAction.x = [NSNumber numberWithFloat:origin.x];
    changeAction.y = [NSNumber numberWithFloat:origin.y];
    
    //保存
    NSError *error = nil;
    if (![changeAction.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
    }
}

- (void)doubleTap:(MemoView *)selectView//(Action *)selectedAction
{
    //タップを無効
    self.doubleTapGesture.enabled = NO;
    
    //デリートモード解除
    [self disappearDeleteBtn];
    
    //色の初期値を代入
    selectCharColor = [selectView.action.charColor integerValue];
    selectMemoColor = [selectView.action.backColor integerValue];
    selectImp = [selectView.action.scrOrMemo integerValue];
    
    [self createInputView_kai:selectView];
    new_or_chage = changeMemo;
    
    //選ばれたViewを保存(actionの特定)
    selectView_change = selectView;
    
    //選ばれたメモを特定
    selectedId = [selectView getMemoId];
    
    //TextViewに初期値を代入
    viewInput_kai.txf.text = selectView.action.memoText;
    
    //Cancel or Delete
    [viewInput_kai cancelOrDelete:1];
    
    //New or Change
//    isNew = changeMemo;
    
}

- (void)pushedDeleteBtn:(MemoView *)deleteMemo
{
    //選ばれたViewを保存(actionの特定)
    selectView_change = deleteMemo;
    
    //選ばれたメモを特定
    selectedId = [deleteMemo getMemoId];
    [self deleteMemo_kai];
}

- (void)setMode:(MemoView *)selectView
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [selectView setScrMode:[df integerForKey:@"mode"]];
}

//削除モードをONにする
- (void)deleteModeOn
{
    for (int i=0; i<=MemoID_ViewController; i++) {
        if (put_memoView[i]) {
            [put_memoView[i] appearDeleteBtn];
        }
    }
}

#pragma mark InputViewのデリゲート
- (void)deleteMemo
{
//    [self undoRegist];
//    [self deleteMemo_kai];
    [self delete_memoView];
    //ダブルタップの解除
    self.doubleTapGesture.enabled = YES;
    [self initialize];

}

- (void)okMemo:(UITextField *)txf
{
    [self textFieldShouldReturn:txf];

}

- (void)judgeCharColor:(UIButton *)selectBtnColor
{
    selectCharColor = selectBtnColor.tag;
    viewInput_kai.txf.textColor = [self savedCharColor:selectBtnColor.tag];

}

- (void)judgeMemoColor:(UIButton *)selectBtnColor
{
    selectMemoColor = selectBtnColor.tag;
    viewInput_kai.txf.backgroundColor = [self savedMemoColor:selectBtnColor.tag];
}

- (void)judgeImportant:(UIButton *)impBtn
{
    selectImp = impBtn.tag;
}

#pragma mark AlartViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //保存準備
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    switch (buttonIndex) {
        case 1:
            if (alartScd == alertView) {
        [self setScrViewToolBarItems];
        [self.scrView setString];
        [df setInteger:ScrollViewMode forKey:@"mode"];
        self.scrView.scrollEnabled = YES;
        
        //memoViewにMode伝達
    }else if (alartMemo == alertView) {
        [scrBar removeFromSuperview];
        [df setInteger:MemoViewMode forKey:@"mode"];
        [self.scrView deleteSchedule];
        self.scrView.contentOffset = CGPointMake(0, 0);
        self.scrView.scrollEnabled = NO;
        [self upMemo];
    }
            break;
            
        default:
            break;
    }
    
    //デリートモード解除
    [self disappearDeleteBtn];
    
    
}

#pragma mark MemoScrollViewDelegate
- (void)doubleTap
{
//    NSLog(@"double");
}

- (void)oneTap
{
    [self disappearDeleteBtn];
}



#pragma mark dealloc

- (void)dealloc{
    
    [super dealloc];
//    [memoView release];
//    [self release];
//    [_scrView release];
    [_doubleTapGesture release];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touche");
//}




@end
