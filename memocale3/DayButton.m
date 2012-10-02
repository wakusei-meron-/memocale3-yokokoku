//
//  DayButton.m
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/23.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import "DayButton.h"
#import "AppDelegate.h"

@implementation DayButton
@synthesize delegate,buttonDate;

- (id)buttonWithFrame:(CGRect)buttonFrame{
    self = [DayButton buttonWithType:UIButtonTypeCustom];
    
    self.frame = buttonFrame;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self addTarget:delegate action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //ボタンの文字の影
    self.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    //ボタンの文字の大きさ
//    self.titleLabel.minimumFontSize = 20.0;
    
    
    
    //UILabelの生成
    CGRect lblfrm = CGRectMake(self.bounds.size.width/2.0 - 25/2.0, self.bounds.size.height/3.0 + 5, 25, 25);
    lbl_NumMemo = [[[UILabel alloc] initWithFrame:lblfrm] autorelease];
    lbl_NumMemo.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    [self addSubview:lbl_NumMemo];
    lbl_NumMemo.textAlignment = UITextAlignmentCenter;
    lbl_NumMemo.textColor = [UIColor whiteColor];
    lbl_NumMemo.hidden = YES;
    
    lbl_NumMemo.font = [UIFont fontWithName:@"Helvetica" size:15];
    //UILabelのCALayer
    CALayer *layer = lbl_NumMemo.layer;
    layer.cornerRadius = 6;
    
    //ダブルタップ
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnDoubleTap)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    
    
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UILabel *titleLabel = [self titleLabel];
    CGRect labelFrame = titleLabel.frame;
    labelFrame.origin.x = self.bounds.size.width /2.0;//self.bounds.size.width - labelFrame.size.width -framePadding;
    labelFrame.origin.y = -1;//framePadding;
    
    CGPoint _center;
    _center = CGPointMake( self.bounds.size.width / 2.0 , 12);
    [self titleLabel].frame = labelFrame;

    self.titleLabel.center = _center;

    //[self addSubview:titleLabel];
//    CGRect lblfrm = CGRectMake(self.bounds.origin.x + 1.0, self.bounds.size.height/3.0, self.bounds.size.width-2.0, self.bounds.size.height/3.0*2.0);
//    UILabel *lbl_NumMemo = [[[UILabel alloc] initWithFrame:lblfrm] autorelease];
//    lbl_NumMemo.backgroundColor = [UIColor redColor];
//    [self addSubview:lbl_NumMemo];
//    lbl_NumMemo.text = @"1";
//    lbl_NumMemo.textAlignment = UITextAlignmentCenter;
//    lbl_NumMemo.textColor = [UIColor whiteColor];
    [self sarch_num];
    
}

//今日のメモの数を数える
- (void)sarch_num
{
    //appDelegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //データベースから読み取るリクエスト作成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] autorelease];
    
    //取得するエンティティの設定
    NSEntityDescription *entityDescription;
    entityDescription = [NSEntityDescription entityForName:@"Action" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //ソート条件配列を作成
    NSSortDescriptor *desc;
    desc = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES] autorelease];
    
    NSArray *sortDescriptor = [[[NSArray alloc] initWithObjects:desc, nil] autorelease];
    [fetchRequest setSortDescriptors:sortDescriptor];
    
    //取得条件の設定
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp == %@",buttonDate];
    [fetchRequest setPredicate:predicate];
    
    //取得最大数の設定？？
    [fetchRequest setFetchBatchSize:20];
    
    //データ取得用コントローラの作成
    NSFetchedResultsController *resurtController;
    resurtController = [[[NSFetchedResultsController alloc] 
                          initWithFetchRequest:fetchRequest 
                          managedObjectContext:appDelegate.managedObjectContext
                          sectionNameKeyPath:nil 
                          cacheName:@"Action"] autorelease];
    
    //DBから値の取得
    NSError *error = nil;
    if (![resurtController performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@",error , [error userInfo]);
    }
    
    //取得結果をNSArrayに代入
    NSArray *resurt = [resurtController fetchedObjects];
    
    //何かメモがあればUILabelを表示してカウント//生成してカウント！！
    if ([resurt count] >= 1 ) {

        lbl_NumMemo.text = [NSString stringWithFormat:@"%d",[resurt count]];
        lbl_NumMemo.hidden = NO;
    }else {
        lbl_NumMemo.hidden = YES;
    }
    
    //重要かどうかのチェック
    //データベースから読み取るリクエスト作成
//    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] autorelease];
//    
//    //取得するエンティティの設定
//    NSEntityDescription *entityDescription2;
//    entityDescription = [NSEntityDescription entityForName:@"Action" inManagedObjectContext:appDelegate.managedObjectContext];
//    [fetchRequest2 setEntity:entityDescription2];
//    
//    //ソート条件配列を作成
//    NSSortDescriptor *desc2;
//    desc2 = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES] autorelease];
//    
//    NSArray *sortDescriptor2 = [[[NSArray alloc] initWithObjects:desc2, nil] autorelease];
//    [fetchRequest2 setSortDescriptors:sortDescriptor2];
    
    //取得条件の設定(重要か)
//    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"scrOrMemo == %d",1];
    
//    //複数条件を設定する
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:predicate];
//    [array addObject:predicate2];
//    
//    NSPredicate *predicates = [NSCompoundPredicate andPredicateWithSubpredicates:array];
//    
//    [fetchRequest setPredicate:predicates];
    
//    //取得最大数の設定？？
//    [fetchRequest2 setFetchBatchSize:20];
    
    //データ取得用コントローラの作成
//    NSFetchedResultsController *resurtController2;
//    resurtController2 = [[[NSFetchedResultsController alloc] 
//                         initWithFetchRequest:fetchRequest 
//                         managedObjectContext:appDelegate.managedObjectContext
//                         sectionNameKeyPath:nil 
//                         cacheName:@"Action"] autorelease];
//    
//    //DBから値の取得
//    NSError *error2 = nil;
//    if (![resurtController2 performFetch:&error2]) {
//        NSLog(@"Unresolved error %@ %@",error2 , [error2 userInfo]);
//    }
//    
//    //取得結果をNSArrayに代入
//    NSArray *resurt2 = [resurtController2 fetchedObjects];
//    
//    if ([resurt2 count]> 0) {
//        [self chageRedImportant];
//        resurt2 = nil;
//    }else {
//        lbl_NumMemo.backgroundColor = [UIColor blackColor];
//    }
}

//今日の色を変える
- (void)setTodayColor
{
    lbl_NumMemo.textColor = [UIColor blackColor];
    lbl_NumMemo.backgroundColor = [UIColor whiteColor];
    

}

//今日の色を戻す
- (void)returnColor
{
    lbl_NumMemo.textColor = [UIColor whiteColor];
    lbl_NumMemo.backgroundColor = [UIColor blackColor];
}
                                                
 
//ダブルタップしたらすぐかけるように
- (void)btnDoubleTap
{

    [self.delegate buttonDoubleTap:self];
}

//重要なら色を変える
- (void)chageRedImportant
{
    lbl_NumMemo.backgroundColor = [UIColor redColor];
}


- (void)dealloc{
    [super dealloc];
}

@end
