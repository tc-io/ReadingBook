//
//  ReadingRootViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-9-30.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "MainViewController.h"
#import "SettingViewController.h"

#import "SecondLevelViewController.h"
#import "TxtViewController.h"
#import "PageViewController.h"

@interface MainViewController ()

// store the recent read book in a plist file.
@property (strong, nonatomic) NSString *recentReadBookInfoPlistPath;

@end

@implementation MainViewController
static NSString *RootLevelCell = @"MainViewCell";

@synthesize allBooksInfo;
@synthesize recentReadBookInfo;
@synthesize recentReadBookInfoPlistPath;

- (id)init{
    self = [super initWithNibName:Nil bundle:Nil];
    self.title = @"主菜单";
    //UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightBarButtonAction:)];
    //self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.allBooksInfo = [[NSMutableDictionary alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    self.recentReadBookInfoPlistPath = [path stringByAppendingPathComponent:@"RecentReadBookInfo.plist"];
    if ([fileManager fileExistsAtPath:self.recentReadBookInfoPlistPath])
    {
        self.recentReadBookInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:self.recentReadBookInfoPlistPath];
        [self checkRecentBookIsExist];
    }
    else
    {
        self.recentReadBookInfo = [[NSMutableDictionary alloc] init];
        [self.recentReadBookInfo writeToFile:self.recentReadBookInfoPlistPath atomically:YES];
    }
    return self;
}

- (void) getAllBooksInfoListFromPath: (NSString *) searchPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:searchPath error:nil];
    BOOL isDir = NO;
    for (NSString *file in fileList)
    {
        NSString *path = [searchPath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (!isDir)
        {
            if ([[file pathExtension]  isEqualToString: @"txt"] || [[file pathExtension] isEqualToString:@"pdf"])
            {
                NSString *currentReadPageNumString = [NSString stringWithFormat:@"%d",[self getBookCurrentReadPageNumber:path]];
                [self.allBooksInfo setValue:currentReadPageNumString forKey:path];
            }
        }
        else
        {
            [self getAllBooksInfoListFromPath:path];
            isDir = NO;
        }
    }
}

- (NSInteger) getBookCurrentReadPageNumber: (NSString *) bookPath
{
    NSInteger currentReadPageNum = 1;
    if ([self.recentReadBookInfo valueForKey:bookPath] != Nil)
    {
        currentReadPageNum = [[self.recentReadBookInfo valueForKey:bookPath] integerValue];
    }
    return currentReadPageNum;
}

- (void) addBookInfoToRecentReadList: (NSString *) bookPath :(NSInteger) currentReadPageNumber;
{
    if ([self.recentReadBookInfo objectForKey:bookPath] != Nil)
    {
        if ([self getBookCurrentReadPageNumber:bookPath] != currentReadPageNumber) {
            [self updateBookInfo:bookPath :currentReadPageNumber];
        }
    }
    else{
        NSString *currentReadPageNumString = [NSString stringWithFormat:@"%d", currentReadPageNumber];
        [self.recentReadBookInfo setValue:currentReadPageNumString forKey:bookPath];
    }
}

- (void) updateBookInfo: (NSString *) bookPath :(NSInteger) currentReadPageNumber
{
    NSString *currentReadPageNumString = [NSString stringWithFormat:@"%d", currentReadPageNumber];
    [self.recentReadBookInfo setValue:currentReadPageNumString forKey:bookPath];
    [self.allBooksInfo setValue:currentReadPageNumString forKey:bookPath];
    [self.tableView reloadData];
}

- (void) removeBookInfoFromDictionary: (NSString *) bookPath
{
    if ([self.allBooksInfo valueForKey:bookPath] != Nil)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:bookPath error:Nil];
       [self.allBooksInfo removeObjectForKey:bookPath];
    }
    if ([self.recentReadBookInfo valueForKey:bookPath] != Nil)
    {
        [self.recentReadBookInfo removeObjectForKey:bookPath];
    }
}

- (void) checkRecentBookIsExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (int i = 0; i<[self.recentReadBookInfo count]; i++)
    {
        NSString *bookPath = [[self.recentReadBookInfo allKeys] objectAtIndex:i];
        if ([fileManager fileExistsAtPath:bookPath] == FALSE)
            [self removeBookInfoFromDictionary:bookPath];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.recentReadBookInfo writeToFile:self.recentReadBookInfoPlistPath atomically:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];
    [self getAllBooksInfoListFromPath:documentDir];
    
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    //Book List View
//    BooksListViewController *booksListViewController = [[BooksListViewController alloc]initWithStyle:UITableViewStylePlain];
//    booksListViewController.title = @"Books List";
//    booksListViewController.bookDisplayImage = [UIImage imageNamed:@"disclosureButtonControllerIcon.png"];
//    [array addObject:booksListViewController];
//    
//    //Setting View
//    SettingViewController *settingViewController = [[SettingViewController alloc] init];
//    settingViewController.title = @"Setting";
//    [array addObject:settingViewController];
//    
//    //Recent Read Book List
//    RecentReadListViewController *recentReadListViewController = [[RecentReadListViewController alloc] init];
//    recentReadListViewController.title = @"Recent Read List";
//    [array addObject:recentReadListViewController];
//    
//    self.controllers = array;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RootLevelCell];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.recentReadBookInfo count];
    }
    else {
        return [self.allBooksInfo count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RootLevelCell forIndexPath:indexPath];
    if (cell ==  Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RootLevelCell];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [fileManager displayNameAtPath: [[self.recentReadBookInfo allKeys] objectAtIndex:indexPath.row]];
    }
    else{
        
        cell.textLabel.text = [fileManager displayNameAtPath:[[self.allBooksInfo allKeys] objectAtIndex:indexPath.row]];
    }
    //cell.imageView.image = controller.rowImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"最近阅读";
    else
        return @"本地图书列表";
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[NSString alloc] init];
    if (indexPath.section == 0)
        filePath = [[self.recentReadBookInfo allKeys] objectAtIndex:indexPath.row];
    else
        filePath = [[self.allBooksInfo allKeys] objectAtIndex:indexPath.row];
    
    if ([[fileManager displayNameAtPath:filePath]hasSuffix:@"txt"])
    {
        TxtViewController *readController = [[TxtViewController alloc] initWithBookPath:filePath];
        [self.navigationController pushViewController:readController animated:YES];
    }
    if ([[fileManager displayNameAtPath:filePath]hasSuffix:@"pdf"])
    {
        PageViewController *pageViewController = [[PageViewController alloc] initWithPDFAtPath:filePath];
        pageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
    [self addBookInfoToRecentReadList:filePath :1];
    [self.tableView reloadData];
}

//设置可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)rightBarButtonAction:(id)sender
{
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.title = @"阅读设置";
    [self.navigationController pushViewController:settingViewController animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.recentReadBookInfo removeObjectForKey:[[self.recentReadBookInfo allKeys] objectAtIndex:indexPath.row]];
        [self.recentReadBookInfo writeToFile:self.recentReadBookInfoPlistPath atomically:YES];
    }
    if (indexPath.section == 1) {
        NSFileManager *fileManger = [NSFileManager defaultManager];
        [fileManger removeItemAtPath:[[self.allBooksInfo allKeys] objectAtIndex:indexPath.row] error:Nil];
        [self.allBooksInfo removeObjectForKey:[[self.allBooksInfo allKeys] objectAtIndex:indexPath.row]];
        [self checkRecentBookIsExist];
    }
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

@end