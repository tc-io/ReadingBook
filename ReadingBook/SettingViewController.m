//
//  SettingViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-11.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "SettingViewController.h"
#import "FontColorSecectActionSheet.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize settingListData;
@synthesize settingTableView;
@synthesize settingViewCell;
@synthesize settingConfig;

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
    self.settingTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.view addSubview:self.settingTableView];
    
    self.settingConfig = [[NSMutableArray alloc] init];
    
    // Read Setting plist file and get view config
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"SettingProperty" ofType:@"plist"];
    
    //    NSMutableArray *accessSettingAry = [[NSMutableArray alloc] initWithObjects:@"iCould账号",@"本地口令", nil];
    //    NSMutableArray *readSettingAry = [[NSMutableArray alloc] initWithObjects:@"字体颜色",@"阅读背景颜色",@"阅读背景",@"无操作退出",@"屏幕长背光",@"自动打开上次阅读",@"阅读进度条",@"压缩空行",@"字体带下划线",@"字体平滑",@"翻页保留最后一行",@"夜间模式",@"自动全屏", nil];
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:accessSettingAry,@"Access Setting",readSettingAry,@"Reading Setting", nil];
    //    [dict writeToFile:plistPath atomically:YES];
    //    self.settingListData = dict;
    NSDictionary *settingPropertyDir = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.settingListData = settingPropertyDir;
    
    for (int i = 0; i<[[self.settingListData allKeys] count]; i++) {
        NSDictionary *nsd =[self.settingListData objectForKey:[[self.settingListData allKeys]objectAtIndex:i]];
        NSMutableArray *nsmuary = [[NSMutableArray alloc]init];
        for (int j = 0; j<[[nsd allKeys]count]; j++) {
            [nsmuary addObject:[[nsd allValues] objectAtIndex:j]];
        }
        [self.settingConfig addObject:nsmuary];
    }
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(clickRightBarButton:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    NSLog(@"View Did Load");

}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [settingListData count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.settingListData objectForKey:[[self.settingListData allKeys] objectAtIndex:section]]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifer = @"TableCellIndentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifer];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifer];
    }
    NSString *cellContent = [[NSString alloc] init];
    cellContent = [[[self.settingListData objectForKey:[[self.settingListData allKeys] objectAtIndex:indexPath.section]] allKeys]objectAtIndex:indexPath.row];
    cell.textLabel.text = cellContent;
    if ([cellContent isEqualToString:@"字体颜色"] || [cellContent isEqualToString:@"阅读背景颜色"] || [cellContent isEqualToString:@"阅读背景"]) {
        NSString *cellConfig = [[self.settingConfig objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        NSLog(@"%@",cellConfig);
    }
    else{
        BOOL cellb = [(NSNumber*)[[self.settingConfig objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue];
        UISwitch *switchView = [[UISwitch alloc] init];
        [switchView setOn:cellb animated:YES];
        [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.settingListData allKeys]objectAtIndex:section];
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

- (void)clickRightBarButton:(id)sender
{
    NSLog(@"Click Right Bar Button");
}

- (IBAction)updateSwitchAtIndexPath:(id)sender
{
    NSInteger section = [self.settingTableView indexPathForCell:((UITableViewCell*)[[sender superview]superview])].section;
    NSInteger row = [self.settingTableView indexPathForCell:((UITableViewCell*)[[sender superview]superview])].row;
    NSLog(@"section ->%d, row -> %d",section,row);
    UISwitch *switchView = (UISwitch *)sender;
        if ([switchView isOn]) {
        NSLog(@"ON");
    }
    else{
        NSLog(@"OFF");
    }
    NSNumber *switchStatue =[[NSNumber alloc]initWithBool:[switchView isOn]];
    [[self.settingConfig objectAtIndex:section] setObject:switchStatue atIndex:row];
}

@end
