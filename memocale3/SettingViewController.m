//
//  SettingViewController.m
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/24.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIColor *backColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"square-paper.png"]];
        self.view.backgroundColor = backColor;
        
        CGRect top_rect = CGRectMake(60, 75, 210, 45);
        CGRect pd_rect, a_rect, pg_rect, g_rect, d_rect, h_rect;
        pd_rect = CGRectMake(40, 145, 160, 30);
        a_rect  = CGRectMake(130, 190, 160, 30);
        pg_rect = CGRectMake(40, 235, 160, 30);
        g_rect  = CGRectMake(130, 280, 160, 30);
        d_rect  = CGRectMake(40, 325, 160, 30);
        h_rect  = CGRectMake(130, 370, 160, 30);
        memocalesStaff = [[[MemoView alloc] initWithFrame:top_rect] autorelease];
        produce = [[[MemoView alloc] initWithFrame:pd_rect] autorelease];
        akinori = [[[MemoView alloc] initWithFrame:a_rect] autorelease];
        program = [[[MemoView alloc] initWithFrame:pg_rect] autorelease];
        genki   = [[[MemoView alloc] initWithFrame:g_rect] autorelease];
        design  = [[[MemoView alloc] initWithFrame:d_rect] autorelease];
        hitomi  = [[[MemoView alloc] initWithFrame:h_rect] autorelease];
            
        [memocalesStaff checkImp];
        [produce checkImp];
        [akinori checkImp];
        [program checkImp];
        [genki checkImp];
        [design checkImp];
        [hitomi checkImp];
        
        [self.view addSubview:memocalesStaff];
        [self.view addSubview:produce];
        [self.view addSubview:akinori];
        [self.view addSubview:program];
        [self.view addSubview:genki];
        [self.view addSubview:design];
        [self.view addSubview:hitomi];
        
        memocalesStaff.lbl_memo.text = @"MemoCale created by";
        memocalesStaff.lbl_memo.backgroundColor = [self savedMemoColor:PORANGE];
        memocalesStaff.lbl_memo.font = [UIFont fontWithName:@"Helvetica" size:20];
        produce.lbl_memo.text = @"Produce";
        produce.lbl_memo.backgroundColor = [self savedMemoColor:PYELLOW];
        akinori.lbl_memo.text = @"@jyukinoriya";
        akinori.lbl_memo.backgroundColor = [self savedMemoColor:PRED];
        program.lbl_memo.text = @"Program";
        program.lbl_memo.backgroundColor = [self savedMemoColor:PYELLOW];
        genki.lbl_memo.text = @"@b0941015";
        genki.lbl_memo.backgroundColor = [self savedMemoColor:PSUNGREEN];
        design.lbl_memo.text = @"Design";
        design.lbl_memo.backgroundColor = [self savedMemoColor:PYELLOW];
        hitomi.lbl_memo.text = @"htm";
        hitomi.lbl_memo.backgroundColor = [self savedMemoColor:PPINK];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [memocalesStaff release];
    memocalesStaff = nil;
    [produce release];
    produce = nil;
    [akinori release];
    akinori = nil;
    [program release];
    program = nil;
    [genki release];
    genki = nil;
    [design release];
    design = nil;
    [hitomi release];
    hitomi = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissModalViewControllerAnimated:YES];
}

- (UIColor *)savedMemoColor:(int)colorNum
{
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

- (void)dealloc {
    [memocalesStaff release];
    [produce release];
    [akinori release];
    [program release];
    [genki release];
    [design release];
    [hitomi release];
    [super dealloc];
}
@end
