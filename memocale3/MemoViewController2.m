//
//  MemoViewController2.m
//  memocale3-yokokoku
//
//  Created by 石橋 弦樹 on 12/04/27.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import "MemoViewController2.h"

@interface MemoViewController2 ()

@end

@implementation MemoViewController2

@synthesize delegate2 = _delegate2;

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
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate2 change];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
