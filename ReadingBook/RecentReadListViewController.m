//
//  RecentReadListViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-19.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "RecentReadListViewController.h"
#import "PageModelViewController.h"

static NSString *RecentReadCellIdentifier = @"BooksListCell";

@implementation RecentReadListViewController
@synthesize recentReadBookInfo;
@synthesize bookDisplayImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.recentReadBookInfo = [[NSMutableArray alloc]init];
    NSLog(@"View Did Load");
    NSString *s1 = @"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/1.pdf";
    NSString *s2 = @"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/2.pdf";
    NSString *s3 = @"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/3.pdf";
    NSString *s4 = @"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/4.pdf";
    [self addBookInfoToDictionary:s1];
    [self addBookInfoToDictionary:s2];
    [self addBookInfoToDictionary:s3];
    [self addBookInfoToDictionary:s4];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RecentReadCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addBookInfoToDictionary:(NSString*)bookPath
{
    if (![self.recentReadBookInfo containsObject:bookPath]) {
        [self.recentReadBookInfo addObject:bookPath];
    }
}

- (void) checkRecentBookIsExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *i in self.recentReadBookInfo) {
        if (![fileManager fileExistsAtPath:i])
            [self.recentReadBookInfo removeObject:i];
    }
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentReadBookInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecentReadCellIdentifier];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RecentReadCellIdentifier];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    cell.textLabel.text = [fileManager displayNameAtPath:[self.recentReadBookInfo objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedBookPath = [self.recentReadBookInfo objectAtIndex:indexPath.row];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *selectedBook = [fileManager displayNameAtPath:[self.recentReadBookInfo objectAtIndex:indexPath.row]];
    
    if ([selectedBook hasSuffix:@"txt"]) {
        //        readController = [[TxtViewController alloc] initWithBookName:selectedBook :@"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents"];
        //      [self.navigationController pushViewController:self.readController animated:YES];
    }
    else if([selectedBook hasSuffix:@"pdf"]){
        //    NSString *filePath = [[NSString alloc]initWithFormat:@"%@/%@",@"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents",selectedBook];
        PageModelViewController *pageModelViewController = [[PageModelViewController alloc] initWithFilePath:selectedBookPath];
        [self.navigationController pushViewController:pageModelViewController animated:YES];
    }
}

@end