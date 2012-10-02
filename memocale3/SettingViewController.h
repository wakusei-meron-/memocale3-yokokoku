//
//  SettingViewController.h
//  memocale3
//
//  Created by 石橋 弦樹 on 12/03/24.
//  Copyright (c) 2012年 横浜国立大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoView.h"

@interface SettingViewController : UIViewController
{
    
    MemoView *memocalesStaff;
    IBOutlet MemoView *produce;
    IBOutlet MemoView *akinori;
    IBOutlet MemoView *program;
    IBOutlet MemoView *genki;
    IBOutlet MemoView *design;
    IBOutlet MemoView *hitomi;
}

@end
