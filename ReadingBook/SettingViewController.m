//
//  SettingViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-11.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "SettingViewController.h"
#import "LTHPasscodeViewController.h"

#import "FontColorSecectActionSheet.h"

@implementation SettingViewController

@synthesize settingPlistPath;
@synthesize settingData;

@synthesize settingTableView;
@synthesize settingViewCell;
@synthesize settingDefaults;
@synthesize switchView;


- (id)init {
    self = [super init];
    NSMutableDictionary *readSettingDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *accessSettingDic = [[NSMutableDictionary alloc] init];
self.switchView = [[UISwitch alloc] init];
    
    self.settingDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.settingDefaults valueForKey:@"字体颜色"] == Nil)
        [self.settingDefaults setObject:@"R,G,B" forKey:@"字体颜色"];
    [readSettingDic setValue:[self.settingDefaults valueForKey:@"字体颜色"] forKey:@"字体颜色"];
    if ([self.settingDefaults valueForKey:@"阅读背景"] == Nil)
        [self.settingDefaults setObject:@"R,G,B" forKey:@"阅读背景"];
    [readSettingDic setValue:[self.settingDefaults valueForKey:@"阅读背景"] forKey:@"阅读背景"];
    if ([self.settingDefaults valueForKey:@"无操作退出"] == Nil)
        [self.settingDefaults setObject:@"0" forKey:@"无操作退出"];
    [readSettingDic setValue:[self.settingDefaults valueForKey:@"无操作退出"] forKey:@"无操作退出"];
    if ([self.settingDefaults valueForKey:@"屏幕长背光"] == Nil)
        [self.settingDefaults setObject:@"1" forKey:@"屏幕长背光"];
    [readSettingDic setValue:[self.settingDefaults valueForKey:@"屏幕长背光"] forKey:@"屏幕长背光"];
    if ([self.settingDefaults valueForKey:@"自动打开上次阅读"] == Nil)
        [self.settingDefaults setObject:@"1" forKey:@"自动打开上次阅读"];
    [readSettingDic setValue:[self.settingDefaults valueForKey:@"自动打开上次阅读"] forKey:@"自动打开上次阅读"];
    if ([self.settingDefaults valueForKey:@"夜间模式"] == Nil)
        [self.settingDefaults setObject:@"0" forKey:@"夜间模式"];
    [readSettingDic setValue:[self.settingDefaults valueForKey:@"夜间模式"] forKey:@"夜间模式"];
    if ([self.settingDefaults valueForKey:@"iCould账号"] == Nil)
        [self.settingDefaults setObject:@"0" forKey:@"iCould账号"];
    [accessSettingDic setValue:[self.settingDefaults valueForKey:@"iCould账号"] forKey:@"iCould账号"];
    if ([self.settingDefaults valueForKey:@"本地口令"] == Nil)
        [self.settingDefaults setObject:@"0" forKey:@"本地口令"];
    [accessSettingDic setValue:[self.settingDefaults valueForKey:@"本地口令"] forKey:@"本地口令"];
    [self.settingDefaults synchronize];
    self.settingData = [[NSMutableArray alloc] initWithObjects:readSettingDic,accessSettingDic, nil];

    CGRect frame = self.view.bounds;
    //    frame.origin.x = 40.0f;
    frame.size.width -= 40.0f;
    self.settingTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.view addSubview:self.settingTableView];
    
    // Read Setting plist file and get view config    
    //self.settingPlistPath = [[NSBundle mainBundle] pathForResource:@"SettingProperty" ofType:@"plist"];

    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"字体颜色:%@",[self.settingDefaults valueForKey:@"字体颜色"]);
    NSLog(@"阅读背景:%@",[self.settingDefaults valueForKey:@"阅读背景"]);
    NSLog(@"无操作退出:%@",[self.settingDefaults valueForKey:@"无操作退出"]);
    NSLog(@"屏幕长背光:%@",[self.settingDefaults valueForKey:@"屏幕长背光"]);
    NSLog(@"自动打开上次阅读:%@",[self.settingDefaults valueForKey:@"自动打开上次阅读"]);
    NSLog(@"夜间模式:%@",[self.settingDefaults valueForKey:@"夜间模式"]);
    NSLog(@"iCould账号:%@",[self.settingDefaults valueForKey:@"iCould账号"]);
    NSLog(@"本地口令:%@",[self.settingDefaults valueForKey:@"本地口令"]);
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.settingData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIdentifer = @"SettingCellIndentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifer];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellIdentifer];
    }
    
    NSString *cellContent = [NSString stringWithFormat:@"%@",[[[self.settingData objectAtIndex:indexPath.section] allKeys] objectAtIndex:indexPath.row]];
    NSString *cellConfig = [[self.settingData objectAtIndex:indexPath.section] valueForKey:cellContent];
    cell.textLabel.text = cellContent;
    if ([cellContent isEqualToString:@"字体颜色"] || [cellContent isEqualToString:@"阅读背景"] || [cellContent isEqualToString:@"阅读背景"]) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    else{
        if ([cellContent isEqualToString:@"本地口令"]){
            if ([LTHPasscodeViewController passcodeExistsInKeychain]){
                [self.switchView setOn:YES animated:YES];
                if ([cellConfig isEqualToString:@"NO"]) {
                    [self.settingDefaults setValue:@"YES" forKey:@"本地口令"];
                    [self.settingDefaults synchronize];
                }
            }
            else{
                [self.switchView setOn:NO animated:YES];
                if ([cellConfig isEqualToString:@"YES"]) {
                    [self.settingDefaults setValue:@"NO" forKey:@"本地口令"];
                    [self.settingDefaults synchronize];
                }
            }
            [self.switchView addTarget:self action:@selector(localPasswordSwitch:) forControlEvents: UIControlEventValueChanged];
            cell.accessoryView = self.switchView;
        }
        else{
            UISwitch *normalSwitch = [[UISwitch alloc] init];
            normalSwitch.tag = indexPath.section*10 + indexPath.row;
            [normalSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = normalSwitch;
        }
    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.settingData objectAtIndex:section] count]>2)
        return @"阅读设置";
    else
        return @"访问设置";
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
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

- (void)localPasswordSwitch:(id)sender {
    UISwitch *changeSwitch = (UISwitch *)sender;
    //    [self.settingData writeToFile:self.settingPlistPath atomically:YES];
    NSString *changeSwitchStateString = [NSString stringWithFormat:@"%u",changeSwitch.on];
    NSLog(@"tag <%d> state is %@",changeSwitch.tag,changeSwitchStateString);
    if (changeSwitch.on){
        [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController: self];
    }
    else{
        [[LTHPasscodeViewController sharedUser] showForTurningOffPasscodeInViewController: self];
    }
}

- (void)updateSwitchAtIndexPath:(id)sender {
    UISwitch *changeSwitch = (UISwitch *)sender;
    NSString *changeSwitchStateString = [NSString stringWithFormat:@"%u",changeSwitch.on];
    NSLog(@"tag <%d> state is %@",changeSwitch.tag,changeSwitchStateString);
    //    [self.settingData writeToFile:self.settingPlistPath atomically:YES];
    switch (changeSwitch.tag) {
        case 1:
            [self.settingDefaults setValue:changeSwitchStateString forKey:@"无操作退出"];
            break;
        case 2:
            [self.settingDefaults setValue:changeSwitchStateString forKey:@"屏幕长背光"];
            break;
        case 4:
            [self.settingDefaults setValue:changeSwitchStateString forKey:@"自动打开上次阅读"];
            break;
        case 5:
            [self.settingDefaults setValue:changeSwitchStateString forKey:@"夜间模式"];
            break;
        case 11:
            [self.settingDefaults setValue:changeSwitchStateString forKey:@"iCould账号"];
            break;
        default:
            break;
    }
    [self.settingDefaults synchronize];
}

- (void) viewWillAppear:(BOOL)animated{
    if ([LTHPasscodeViewController passcodeExistsInKeychain]){
        [self.switchView setOn:YES animated:YES];
        [self.settingDefaults setValue:@"YES" forKey:@"本地口令"];
        [self.settingDefaults synchronize];
    }
    else{
        [self.switchView setOn:NO animated:YES];
        [self.settingDefaults setValue:@"NO" forKey:@"本地口令"];
        [self.settingDefaults synchronize];
    }
}

- (void) saveConfigToPlistFile {
    [self.settingData writeToFile:self.settingPlistPath atomically:YES];
}

- (NSString *) getSettingConfigByKeyword:(NSString*) configKeyword {
    for (int i=0; i<[self.settingData count]; i++) {
        if ([[[self.settingData objectAtIndex:i] allKeys] indexOfObject:configKeyword]!= NSNotFound)
            return [[self.settingData objectAtIndex:i] valueForKey:configKeyword];
    }
    return  Nil;
}

@end