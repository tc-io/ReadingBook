//
//  BooksListViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-2.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "AllBooksListViewController.h"

#import "TxtViewController.h"
#import "PageViewController_Model.h"

static NSString *CellIdentifier = @"ALLBooksListCell";

@implementation AllBooksListViewController

@synthesize allBooks;
@synthesize bookDisplayImage;

-(NSMutableDictionary *)getAllBooksList
{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];

    
    NSMutableArray *txtBooksList = [[NSMutableArray alloc] init];
    NSMutableArray *pdfBooksList = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:nil];
    BOOL isDir = NO;
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        NSLog(@"File Extension -> %@", [file pathExtension]);
        //if (!isDir) {
        if ([[file pathExtension]  isEqualToString: @"txt"]) {
            [txtBooksList addObject:file];
        }
        
        if ([[file pathExtension] isEqualToString:@"pdf"]) {
            [pdfBooksList addObject:file];
        }
        // }
        //else{
        //   [allBooks addObjectsFromArray:[self getBooksList:path]];
        //}
        //isDir = NO;
    }
    NSMutableDictionary *books = [[NSMutableDictionary alloc] initWithObjectsAndKeys:txtBooksList,@"TEXT",pdfBooksList,@"PDF", nil];
    return books;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.allBooks = [[NSMutableDictionary alloc] init];
    self.allBooks = [self getAllBooksList];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.navigationController.navigationBar.translucent = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}


#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.allBooks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *bookSection = [[NSMutableArray alloc]init];
    for (NSArray *ar in [self.allBooks allValues]) {
        [bookSection addObject:ar];
    }
    return [[bookSection objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.allBooks objectForKey:[[self.allBooks allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.allBooks allKeys]objectAtIndex:section];
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UIAlertView *alert = [[UIAlertView alloc]
    //                          initWithTitle:@"Hey, do you see the disclosure button?"
    //                          message:@"Touch that to drill down instead."
    //                          delegate:nil
    //                          cancelButtonTitle:@"Won’t happen again"
    //                          otherButtonTitles:nil];
    //    [alert show];
    NSString *selectedBook = [[self.allBooks objectForKey:[[self.allBooks allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    NSLog(@"[AllBooksListViewController.didSelectRowAtIndexPath] SelectedBook ->%@",selectedBook);
    
    if ([selectedBook hasSuffix:@"txt"]) {
        TxtViewController *readController = [[TxtViewController alloc] initWithBookPath:@"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/1.txt"];
        [self.navigationController pushViewController:readController animated:YES];
    }
    else if([selectedBook hasSuffix:@"pdf"]){
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@/%@",@"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents",selectedBook];
        PageViewController_Model *pageModelViewController = [[PageViewController_Model alloc] initWithFilePathAndCurPageNumber:filePath :1];
        [self.navigationController pushViewController:pageModelViewController animated:YES];
    }
    //    /// --- Read Content from text type file
    //    /// *** Solution 1 ***
    //    NSData *data = [NSData dataWithContentsOfFile:@"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/1.txt"];
    //    NSString *textFile = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",textFile);
    //    /// *** End Solution 1 ***
    //
    //    /// *** Solution 2 Read Chinese file ***
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    NSString *textFile1 = [NSString stringWithContentsOfFile:@"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/1.txt" encoding:enc error:nil];
    //    NSLog(@"---Text File Content\n%@---",textFile1);
    //    /// *** End Solution 2 ***
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//
////    self.bookReadController.message = detailMessage;
////    self.bookReadController.title = selectedMovie;
////    [self.navigationController pushViewController:self.bookReadController animated:YES];
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.allBooks objectForKey:[[self.allBooks allKeys] objectAtIndex:indexPath.section]] removeObjectAtIndex:indexPath.row];
    //    if ([[self.books objectForKey:[[self.books allKeys] objectAtIndex:indexPath.section]] count] == 0) {
    //        [self.books removeObjectForKey:[[self.books allKeys] objectAtIndex:indexPath.section]];
    //    }
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refresh {
    [self performSelector:@selector(addItem) withObject:nil afterDelay:2.0];
}

- (void)addItem {
    // Add a new time
    NSMutableArray *testArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<5; i++) {
        NSString *testStr = [[NSString alloc] initWithFormat:@"TestBook/test%d.test",i];
        [testArray addObject:testStr];
    }
    [self.allBooks setObject:testArray forKey:@"TEST"];
    
    [self.tableView reloadData];
    
    [self stopLoading];
}


@end
