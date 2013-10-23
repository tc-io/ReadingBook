//
//  ReadingRootViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-9-30.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "JKReaderRootViewController.h"
#import "SecondLevelViewController.h"
#import "BooksListViewController.h"
#import "SettingViewController.h"
#import "RecentReadListViewController.h"

#import "TxtViewController.h"
#import "PageModelViewController.h"

@implementation JKReaderRootViewController

static NSString *RootLevelCell = @"RootLevelCell";
@synthesize controllers;
@synthesize allBooks;
@synthesize recentReadBookInfo;
@synthesize plistPath;

-(NSMutableArray *)getAllBooksList
{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:nil];
    NSMutableArray *books = [[NSMutableArray alloc]init];
    
    BOOL isDir = NO;
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        //if (!isDir) {
        if ([[file pathExtension]  isEqualToString: @"txt"]) {
            [books addObject:path];
        }
        
        if ([[file pathExtension] isEqualToString:@"pdf"]) {
            [books addObject:path];
        }
        // }
        //else{
        //   [allBooks addObjectsFromArray:[self getBooksList:path]];
        //}
        //isDir = NO;
    }
    return books;
}

- (void) addBookInfoToArray:(NSString*)bookPath
{
    if ([self.recentReadBookInfo count] > 0) {
        for (int i=0; i<[self.recentReadBookInfo count]; i++) {
            if ([[self.recentReadBookInfo objectAtIndex:i] isEqualToString:bookPath]) {
                return;
            }
        }
    }
    [self.recentReadBookInfo addObject:bookPath];
}

- (void) checkRecentBookIsExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *i in self.recentReadBookInfo) {
        if (![fileManager fileExistsAtPath:i])
            [self.recentReadBookInfo removeObject:i];
    }
    [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
}

- (id)init{
    NSLog(@"Root init");
    self = [super initWithNibName:Nil bundle:Nil];
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftBarButtonAction:)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.title = @"Root Level";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"RecentReadBookInfo.plist"];
    
    self.recentReadBookInfo = [[NSMutableArray alloc]init];
    
    allBooks = [[NSMutableArray alloc]initWithArray:[self getAllBooksList]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.plistPath]) {
        self.recentReadBookInfo = [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
        if ([self.recentReadBookInfo count] >0){
            [self checkRecentBookIsExist];
        }
    }
    else{
        self.recentReadBookInfo = [[NSMutableArray alloc] init];
        [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        return @"Recent Read";
    else
        return @"Books list";
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section ->%d, row ->%d",indexPath.section,indexPath.row);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[NSString alloc] init];
    if (indexPath.section == 0)
        filePath = [self.recentReadBookInfo objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        filePath = [self.allBooks objectAtIndex:indexPath.row];
    NSLog(@"%@",filePath);
    if ([[fileManager displayNameAtPath:filePath]hasSuffix:@"txt"]) {
        TxtViewController *readController = [[TxtViewController alloc] initWithBookPath:filePath];
        [self.navigationController pushViewController:readController animated:YES];
    }
    if ([[fileManager displayNameAtPath:filePath]hasSuffix:@"pdf"]) {
        PageModelViewController *pageModelViewController = [[PageModelViewController alloc] initWithFilePath:filePath];
        [self.navigationController pushViewController:pageModelViewController animated:YES];
    }
    [self.recentReadBookInfo addObject:filePath];
}

- (void)leftBarButtonAction:(id)sender
{
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.title = @"Setting";
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)rightBarButtonAction:(id)sender
{
    
}


@end
