//
//  ReadingRootViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-9-30.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKReaderRootViewController : UITableViewController

@property (copy, nonatomic) NSArray *controllers;
@property (strong, nonatomic) NSMutableArray *allBooks;    // [key:file type, value: an array which contaion book path]
@property (strong, nonatomic) NSMutableArray *recentReadBookInfo;   // store the recent read book’s path
@property (strong, nonatomic) NSString *plistPath;  // store the recent read book in a plist file.

- (id) init;

// Function: get all books type and book path, defalt search path is NSDocumentDirectory
// Input: nil
// Return:a dictionary which contain book's path and order by file type
- (NSMutableArray *) getAllBooksList;

// Function: add book's path into the 'recentReadBookInfo' array
// Input: book's path
// Return: void
- (void) addBookInfoToArray:(NSString*)bookPath;

// Function: check all of the book path is exist or not which is in 'recentReadBookInfo' array, if not remove it from 'recentReadBookInfo' array
// Input: nil
// Return: void
- (void) checkRecentBookIsExist;

@end
