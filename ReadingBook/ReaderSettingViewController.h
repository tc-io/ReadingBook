//
//  SettingViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-11.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) UITableView *settingTableView;
@property (strong, nonatomic) UITableViewCell *settingViewCell;

@property (strong, nonatomic) NSString* settingPlistPath;   //  record the setting plist file path
@property (strong, nonatomic) NSMutableDictionary *settingPlistData; //  store the setting'Data


- (id) init;

@end
