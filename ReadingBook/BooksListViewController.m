//
//  BooksListViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-2.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "BooksListViewController.h"
#import "PageViewController.h"
#import "PDFViewer.h"

static NSString *CellIdentifier = @"BooksListCell";

@interface BooksListViewController()
@property (strong, nonatomic) PageViewController *readController;
-(NSMutableArray *)getBooksList:(NSString *)dirPath;
@end

@implementation BooksListViewController

@synthesize books;
@synthesize readController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.books = [[NSMutableArray alloc] init];
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];
    NSLog(@"%@",documentDir);
    self.books = [self getBooksList:documentDir];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

-(NSMutableArray *)getBooksList:(NSString *)dirPath
{
    NSMutableArray *booksList = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
    BOOL isDir = NO;
    for (NSString *file in fileList) {
        NSString *path = [dirPath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (!isDir) {
            [booksList addObject:file];
        }
        else{
            [booksList addObjectsFromArray:[self getBooksList:path]];
        }
        isDir = NO;
    }
    return booksList;
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = self.books[indexPath.row];
    return cell;
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
    NSString *selectedBook = self.books[indexPath.row];
    NSLog(@"Selected Book is ->%@",selectedBook);
    
    if ([selectedBook hasSuffix:@"txt"]) {
            readController = [[PageViewController alloc] init];
        self.readController.title=selectedBook;
        self.readController.bookName = selectedBook;
        [self.navigationController pushViewController:self.readController animated:YES];
    }
    else if ([selectedBook hasSuffix:@"pdf"]) {
            CGRect frame = CGRectMake(0, 0, 200, 300);
        PDFViewer *pdfView = [[PDFViewer alloc] initWithFrame:frame];
        pdfView.backgroundColor = [UIColor redColor];
        //[self.navigationController pushViewController:pdfView animated:YES];
        [self.view addSubview:pdfView];
    }
    else{
        BookReadViewController *bookreadController = [[BookReadViewController alloc]initWithNibName:@"BookReadViewController" bundle:nil];
        bookreadController.title = selectedBook;
        bookreadController.webView.backgroundColor = [UIColor redColor];
        NSString *filePath = @"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/2.pdf";
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
        //bookreadController.webView.scalesPageToFit = YES;
        [self.view setBackgroundColor:[UIColor blueColor]];
        [bookreadController.webView loadRequest:req];
        [bookreadController didMoveToParentViewController:self];
        [self.navigationController pushViewController:bookreadController animated:YES];
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
    [self.books removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touch Begain");
}

@end
