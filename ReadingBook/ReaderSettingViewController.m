//
//  SettingViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-11.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "ReaderSettingViewController.h"
#import "LTHPasscodeViewController.h"

#import "FontColorSecectActionSheet.h"

@implementation ReaderSettingViewController

@synthesize settingPlistPath;
@synthesize settingPlistData;

@synthesize settingTableView;
@synthesize settingViewCell;


- (id)init{
    self = [super init];
    CGRect frame = self.view.bounds;
    frame.origin.x = 40.0f;
    frame.size.width -= 40.0f;
    self.settingTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.view addSubview:self.settingTableView];
    
    // Read Setting plist file and get view config
    NSBundle *bundle = [NSBundle mainBundle];
    self.settingPlistPath = [bundle pathForResource:@"SettingProperty" ofType:@"plist"];
    //    NSMutableArray *accessSettingAry = [[NSMutableArray alloc] initWithObjects:@"iCould账号",@"本地口令", nil];
    //    NSMutableArray *readSettingAry = [[NSMutableArray alloc] initWithObjects:@"字体颜色",@"阅读背景颜色",@"阅读背景",@"无操作退出",@"屏幕长背光",@"自动打开上次阅读",@"阅读进度条",@"压缩空行",@"字体带下划线",@"字体平滑",@"翻页保留最后一行",@"夜间模式",@"自动全屏", nil];
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:accessSettingAry,@"Access Setting",readSettingAry,@"Reading Setting", nil];
    //    [dict writeToFile:plistPath atomically:YES];
    //    self.settingListData = dict;
    NSLog(@"[ReaderSettingViewController.init] Read Setting Plist file, settingPlistPath: %@",self.settingPlistPath);
    self.settingPlistData = [[NSMutableDictionary alloc] initWithContentsOfFile:self.settingPlistPath];
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.settingPlistData count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.settingPlistData objectForKey:[[self.settingPlistData allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingCellIdentifer = @"SettingCellIndentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifer];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellIdentifer];
    }
    
    NSString *cellContent = [[NSString alloc] init];
    cellContent = [[[self.settingPlistData objectForKey:[[self.settingPlistData allKeys] objectAtIndex:indexPath.section]] allKeys]objectAtIndex:indexPath.row];
    cell.textLabel.text = cellContent;
    if ([cellContent isEqualToString:@"字体颜色"] || [cellContent isEqualToString:@"阅读背景颜色"] || [cellContent isEqualToString:@"阅读背景"]) {
        NSString *cellConfig = [[[self.settingPlistData objectForKey:[[self.settingPlistData allKeys] objectAtIndex:indexPath.section]] allValues]objectAtIndex:indexPath.row];
        NSLog(@"[ReaderSettingViewController] Cell Config: %@",cellConfig);
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    else{
        BOOL cellConfig = [[[[self.settingPlistData objectForKey:[[self.settingPlistData allKeys] objectAtIndex:indexPath.section]] allValues]objectAtIndex:indexPath.row] intValue];
        NSLog(@"[ReaderSettingViewController] Cell Config: %hhd",cellConfig);
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.tag = indexPath.row;
        [switchView setOn:cellConfig animated:YES];
        [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.settingPlistData allKeys] objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    FontColorSecectActionSheet* sheet = [[FontColorSecectActionSheet alloc] initWithHeight:284.0f WithSheetTitle:@"自定义ActionSheet"];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:NO];
    
    //    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,50, 320, 50)];
    //    label.text = @"这里是要自定义放的控制";
    //    label.backgroundColor = [UIColor clearColor];
    //    label.textAlignment = UITextAlignmentCenter;
    [sheet.view addSubview:datePicker];
    [sheet showInView:self.view];
    //
    ////    self.bookReadController.message = detailMessage;
    ////    self.bookReadController.title = selectedMovie;
    ////    [self.navigationController pushViewController:self.bookReadController animated:YES];
}

- (void)updateSwitchAtIndexPath:(id)sender{
    UISwitch *changeSwitch = (UISwitch *)sender;
    NSLog(@"Statue %d, Tag %d",changeSwitch.on,changeSwitch.tag);
    if (changeSwitch.on)
    	[[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController: self];
    else
        [[LTHPasscodeViewController sharedUser] showForTurningOffPasscodeInViewController: self];
}

@end