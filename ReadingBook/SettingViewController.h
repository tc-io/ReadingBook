//
//  SettingViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-11.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *settingListData;
@property (strong, nonatomic) UITableView *settingTableView;
@property (strong, nonatomic) UITableViewCell *settingViewCell;
@property (strong, nonatomic) NSMutableArray *settingConfig;

@end
