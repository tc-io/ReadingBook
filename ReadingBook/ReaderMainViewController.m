//
//  ReadingRootViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-9-30.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "ReaderMainViewController.h"
#import "ReaderSettingViewController.h"

#import "SecondLevelViewController.h"
#import "TxtViewController.h"
#import "PageModelViewController.h"

@implementation ReaderMainViewController

static NSString *RootLevelCell = @"MainViewCell";
@synthesize controllers;
@synthesize allBooks;
@synthesize recentReadBookInfo;
@synthesize plistPath;

- (void) getBooksListFromPath:(NSString *)searchPath
{
    NSLog(@"[ReaderMainViewController.getBooksListFromPath] Start");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:searchPath error:nil];
    
    BOOL isDir = NO;
    for (NSString *file in fileList) {
        NSString *path = [searchPath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (!isDir) {
        if ([[file pathExtension]  isEqualToString: @"txt"] || [[file pathExtension] isEqualToString:@"pdf"])
            [self.allBooks addObject:path];
        }
        else{
           [self getBooksListFromPath:path];
        }
        isDir = NO;
    }
    NSLog(@"[ReaderMainViewController.getBooksListFromPath] End");
}

- (void) addBookInforToArray:(NSString*)bookPath
{
    NSLog(@"[ReaderMainViewController.addBookInforToArray] Start");
    if ([self.recentReadBookInfo count] > 0) {
        for (int i=0; i<[self.recentReadBookInfo count]; i++) {
            if ([[self.recentReadBookInfo objectAtIndex:i] isEqualToString:bookPath]) {
                return;
            }
        }
    }
    [self.recentReadBookInfo addObject:bookPath];
    [self.tableView reloadData];
    NSLog(@"[ReaderMainViewController.addBookInforToArray] End");
}

- (void) checkRecentBookIsExist
{
    NSLog(@"[ReaderMainViewController.checkRecentBookIsExist] Start");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (int i=0; i<[self.recentReadBookInfo count]; i++) {
        NSString *filePath = [self.recentReadBookInfo objectAtIndex:i];
        if (![fileManager fileExistsAtPath:filePath]){
            NSLog(@"<%@> is not Exist",filePath);
            [self.recentReadBookInfo removeObjectAtIndex:i];
        }
    }
    [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
    NSLog(@"[ReaderMainViewController.checkRecentBookIsExist] End");
}

- (id)init{
    NSLog(@"[ReaderMainViewController.init] Start");
    self = [super initWithNibName:Nil bundle:Nil];
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.title = @"主菜单";
    self.recentReadBookInfo = [[NSMutableArray alloc]init];
    self.allBooks = [[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"RecentReadBookInfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.plistPath]) {
        self.recentReadBookInfo = [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
        if ([self.recentReadBookInfo count] > 0){
            [self checkRecentBookIsExist];
        }
    }
    else{
        self.recentReadBookInfo = [[NSMutableArray alloc] init];
        [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
    }
    NSLog(@"[ReaderMainViewController.init] End");
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"[ReaderMainViewController.viewWillDisappear] Start");
    [super viewWillDisappear:animated];
    [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
    NSLog(@"[ReaderMainViewController.viewWillDisappear] Write Book information into plist");
    NSLog(@"[ReaderMainViewController.viewWillDisappear] End");
}

- (void)viewDidLoad
{
    NSLog(@"[ReaderMainViewController.viewDidLoad] Start");
    [super viewDidLoad];
    
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];
    [self getBooksListFromPath:documentDir];
    
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
    NSLog(@"[ReaderMainViewController.viewDidLoad] End");
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
        return [self.allBooks count];
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
        cell.textLabel.text = [fileManager displayNameAtPath:[self.recentReadBookInfo objectAtIndex:indexPath.row]];
    }
    else{
        
        cell.textLabel.text = [fileManager displayNameAtPath:[self.allBooks objectAtIndex:indexPath.row]];
    }
    //cell.imageView.image = controller.rowImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
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
        filePath = [self.recentReadBookInfo objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        filePath = [self.allBooks objectAtIndex:indexPath.row];
    if ([[fileManager displayNameAtPath:filePath]hasSuffix:@"txt"]) {
        TxtViewController *readController = [[TxtViewController alloc] initWithBookPath:filePath];
        [self.navigationController pushViewController:readController animated:YES];
    }
    if ([[fileManager displayNameAtPath:filePath]hasSuffix:@"pdf"]) {
        PageModelViewController *pageModelViewController = [[PageModelViewController alloc] initWithFilePath:filePath];
        [self.navigationController pushViewController:pageModelViewController animated:YES];
    }
    [self addBookInforToArray:filePath];
    [self.tableView reloadData];
}

- (void)rightBarButtonAction:(id)sender
{
    ReaderSettingViewController *settingViewController = [[ReaderSettingViewController alloc] init];
    settingViewController.title = @"阅读设置";
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.recentReadBookInfo removeObjectAtIndex:indexPath.row];
        [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
    }
    if (indexPath.section == 1) {
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSLog(@"Remove Book Path is->%@",[self.allBooks objectAtIndex:indexPath.row]);
        [fileManger removeItemAtPath:[self.allBooks objectAtIndex:indexPath.row] error:Nil];
        [self.allBooks removeObjectAtIndex:indexPath.row];
    }
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self checkRecentBookIsExist];
    [self.tableView reloadData];
}


@end
