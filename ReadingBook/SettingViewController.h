//
//  SettingViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-11.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) UITableView *settingTableView;
@property (strong, nonatomic) UITableViewCell *settingViewCell;

@property (strong, nonatomic) NSString* settingPlistPath;   //  record the setting plist file path
@property (strong, nonatomic) NSMutableArray *settingData; //  store the setting'Data
@property (strong, nonatomic) NSUserDefaults *settingDefaults;
@property (strong, nonatomic) UISwitch *switchView;

- (id) init;

// Function: seve self.settingData to the settingPlist file
// Input: Nil
// Return: (void)
- (void) saveConfigToPlistFile;

// Function: get setting config by keyword
// Input: (NSString *)configKeyword
// Return: (NSString *)
- (NSString *) getSettingConfigByKeyword:(NSString*) configKeyword;
@end
