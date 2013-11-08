//
//  ReadingRootViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-9-30.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "MainViewController.h"
#import "ReaderSettingViewController.h"

#import "SecondLevelViewController.h"
#import "TxtViewController.h"
#import "PageModelViewController.h"

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
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    NSBundle *bundle = [NSBundle mainBundle];
    self.recentReadBookInfoPlistPath = [bundle pathForResource:@"RecentReadBookInfo" ofType:@"plist"];
    self.allBooksInfo = [[NSMutableDictionary alloc] init];
    self.recentReadBookInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:self.recentReadBookInfoPlistPath];
    [self checkRecentBookIsExist];

//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:self.plistPath]) {
//        self.recentReadBookInfo = [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
//        if ([self.recentReadBookInfo count] > 0){
//            [self checkRecentBookIsExist];
//        }
//    }
//    else{
//        self.recentReadBookInfo = [[NSMutableArray alloc] init];
//        [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
//    }
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
                NSString *currentReadPageNumString = [[NSString alloc] initWithFormat:@"%d",[self getBookCurrentReadPageNumber:path]];
                [self.allBooksInfo setObject: currentReadPageNumString forKey:path];
            }
            else
                [self getAllBooksInfoListFromPath:path];
            isDir = NO;
        }
    }
}

- (NSInteger) getBookCurrentReadPageNumber: (NSString *) bookPath
{
    NSInteger currentReadPageNum = 1;
    if ([[self.recentReadBookInfo allKeys] valueForKey:bookPath] != Nil)
    {
        currentReadPageNum = [[self.recentReadBookInfo objectForKey:bookPath] integerValue];
        NSLog(@"[ReaderMainViewController.getBookCurrentReadPageNumber] The book<%@> is in the recentReadBookInfo current read page number is <%d>",bookPath, currentReadPageNum);
    }
    return currentReadPageNum;
        
}

- (void) addBookInforToRecentReadList: (NSString *) bookPath :(NSInteger) currentReadPageNumber;
{
    if ([self.recentReadBookInfo valueForKey:bookPath] != Nil)
    {
        if ([self getBookCurrentReadPageNumber:bookPath] != currentReadPageNumber) {
            NSLog(@"[ReaderMainViewController.addBookInforToArray] update the book information, bookPath <%@>, currentReadPageNumber <%d>", bookPath,currentReadPageNumber);
            [self updateBookInfo:bookPath :currentReadPageNumber];
        }
        else{
            NSLog(@"[ReaderMainViewController.addBookInforToArray] There is same book information in the recentReadBookInfo, do nothing");
        }
    }
    else{
        NSLog(@"[ReaderMainViewController.addBookInforToArray] add new book information into recentReadBookInfo, bookPath <%@>, currentReadPageNumber <%d>", bookPath,currentReadPageNumber);
        NSString *currentReadPageNumString = [[NSString alloc] initWithFormat:@"%d", currentReadPageNumber ];
        [self.recentReadBookInfo setObject:currentReadPageNumString forKey:bookPath];
    }
}

- (void) updateBookInfo: (NSString *) bookPath :(NSInteger) currentReadPageNumber
{
    NSString *currentReadPageNumString = [[NSString alloc] initWithFormat:@"%d", currentReadPageNumber ];
    [self.recentReadBookInfo setObject:currentReadPageNumString forKey:bookPath];
    [self.allBooksInfo setObject:currentReadPageNumString forKey:bookPath];
    [self.tableView reloadData];
}

- (void) removeBookInfoFromDictionary: (NSString *) bookPath
{
    if ([self.allBooksInfo valueForKey:bookPath] != Nil)
    {
        NSLog(@"[ReaderMainViewController.removeBookInfoFromDictionary] remove book information from allBooksInfo and delete book, bookPath <%@> ",bookPath);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:bookPath error:Nil];
       [self.allBooksInfo removeObjectForKey:bookPath];
    }
    if ([self.recentReadBookInfo valueForKey:bookPath] != Nil)
    {
        NSLog(@"[ReaderMainViewController.removeBookInfoFromDictionary] remove book information from recentReadBookInfo, bookPath <%@> ",bookPath);
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
    NSLog(@"[ReaderMainViewController.viewWillDisappear] Write Book information into plist");
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
        PageModelViewController *pageModelViewController = [[PageModelViewController alloc] initWithFilePathAndCurPageNumber:filePath :1];
        [self.navigationController pushViewController:pageModelViewController animated:YES];
    }
    [self addBookInforToRecentReadList:filePath :1];
    [self.tableView reloadData];
}

- (void)rightBarButtonAction:(id)sender
{
    ReaderSettingViewController *settingViewController = [[ReaderSettingViewController alloc] init];
    settingViewController.title = @"阅读设置";
    [self.navigationController pushViewController:settingViewController animated:YES];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        [self.recentReadBookInfo removeObjectAtIndex:indexPath.row];
//        [self.recentReadBookInfo writeToFile:self.plistPath atomically:YES];
//    }
//    if (indexPath.section == 1) {
//        NSFileManager *fileManger = [NSFileManager defaultManager];
//        NSLog(@"Remove Book Path is->%@",[self.allBooks objectAtIndex:indexPath.row]);
//        [fileManger removeItemAtPath:[self.allBooks objectAtIndex:indexPath.row] error:Nil];
//        [self.allBooks removeObjectAtIndex:indexPath.row];
//    }
////    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self checkRecentBookIsExist];
//    [self.tableView reloadData];
//}recentReadBookInfoPlistPath	__NSCFString *	@"/Users/Jeff/Library/Application Support/iPhone Simulator/7.0.3/Applications/DF699FEC-EABA-455C-BD0B-3EA8D1D530D2/ReadingBook.app/RecentReadBookInfo.plist"	0x08c21210


@end