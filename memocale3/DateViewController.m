//
//  DateViewController.m
//  memocale3-yokokoku
//
//  Created by 石橋 弦樹 on 12/04/25.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController
@synthesize datepicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datepicker.date = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotifyTime"];
    
    //BarButtonItem
    UIBarButtonItem *btn_right = [[[UIBarButtonItem alloc] initWithTitle:@"保存する" style:UIBarButtonItemStyleBordered target:self action:@selector(pushDateSaveButton)] autorelease];
    self.navigationItem.rightBarButtonItem = btn_right;
    self.navigationItem.leftBarButtonItem.title = @"戻る";
    
}

- (void)viewDidUnload
{
    [self setDatepicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pushDateSaveButton
{
    //変更を伝達
    [[[self.navigationController.viewControllers objectAtIndex:1] tableView] reloadData];
    
    //時間が変わったら一度全ての通知を消して作りなおす
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[self.navigationController.viewControllers objectAtIndex:1] callDelegate];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.datepicker.date forKey:@"NotifyTime"];
    
    //
    [[self.navigationController.viewControllers objectAtIndex:1] callDelegate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [datepicker release];
    [super dealloc];
}
@end
