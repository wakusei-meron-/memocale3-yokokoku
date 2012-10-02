//
//  MemoViewController.h
//  memocale3
//
//  Created by 石橋 弦樹 on 11/12/24.
//  Copyright (c) 2011年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoView.h"
#import "AppDelegate.h"
#import "Action.h"
#import "InputView.h"
#import "MemoScrolView.h"

@protocol MemoViewControllerDelegate;

@interface MemoViewController : UIViewController<UITextFieldDelegate,NSFetchedResultsControllerDelegate,MemoViewDelegate
                                                    ,InputViewDelegate, UIAlertViewDelegate, MemoScrolViewDelegate>
{
    
    int new_or_chage;
    int MemoID_ViewController;//それぞれのメモを区別する変数
//    int ImpOrNot;
    int selectedId;//選択されているID
    NSInteger selectCharColor;//選択されている文字の色
    NSInteger selectMemoColor;//選択されているメモの色
    NSInteger selectImp;//重要かどうか
    CGPoint doubleTapPoint;//タップされた位置
    NSDate *date;
    UITextField *txf_memo;
    UIView *view_Input;
//    UITapGestureRecognizer *doubleTapGesture;//タップの判定
//    NSUndoManager *undoManager;//undoManager
    Action *action[99];
    MemoView *put_memoView[99];
    MemoView *selectView_change;
    
    InputView *viewInput_kai;
    //Viewについて
    UIView *viewBack;
    
    //Scrol Viewについて
    BOOL scrMode;
//    MemoScrolView *scrView;
    UIToolbar *scrBar;
    
    //alart関連
    UIAlertView *alartScd,*alartMemo;
    
    //Newかどうか
    int isNew;
}

@property(retain , nonatomic, strong)NSDate *date;
@property (nonatomic, retain)id<MemoViewControllerDelegate> delegate;
@property (nonatomic, retain)UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, retain)MemoScrolView *scrView;

//ボタン関連
- (void)backCalendar_year;
- (void)plus_memo;
//- (void)undo;

//繰り返しメソッド
- (void)createNewObject:(NSString *)memo;//新しいメモの追加・保存
- (void)load_data;//DBからデータの読み出し
- (void)arrange_memo:(Action *)receivedAction;//メモの配置
//- (void)createInputView:(MemoView *)prepareView;//インプットビューの生成
- (void)createInputView_kai:(MemoView *)prepareView;//インプットビューの生成・改
- (void)changeObject:(NSString *)memo memoView:(MemoView *)changedView;//メモ内容の変更


//NSFetchRequestController
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

@protocol MemoViewControllerDelegate <NSObject>

- (void)MemoDidChangeContent;
- (void)ImpDidChange;

@end
