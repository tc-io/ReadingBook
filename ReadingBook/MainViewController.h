//
//  ReadingRootViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-9-30.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary *allBooksInfo; // [key]: book path, [value]: current read number]
@property (strong, nonatomic) NSMutableDictionary *recentReadBookInfo; // [key]: book path, [value]: current read number]

- (id) init;

// Function: get all books information(type, book path and current read number) store them with a dictionary(allBooksInfo)
// Input: (NSString *) searchPath
// Return: (void)
- (void) getAllBooksInfoListFromPath: (NSString *) searchPath;

// Function: get the book has read number from recent read book list.
// Input: (NSString *) bookPath
// Return: (NSInteger) current read number, if the book path is not in the rectent read book list this function will return 1
- (NSInteger) getBookCurrentReadPageNumber: (NSString *) bookPath;

// Function: add book's information into the 'recentReadBookInfo'
// Input: (NSString*) bookPath :(NSInteger)currentReadPageNumber
// Return: (void)
- (void) addBookInforToRecentReadList: (NSString *) bookPath :(NSInteger) currentReadPageNumber;

// Function: check the book path whether is in 'recentReadBookInfo'
// Input: Nil
// Return: (void)
- (void) checkRecentBookIsExist;

// Function: remove book's information from dictionary
// Input: (NSString *) bookPath
// Return: (void)
- (void) removeBookInfoFromDictionary: (NSString *) bookPath;

// Function: update book's information
// Input: (NSString *) bookPath, (NSInteger) currentReadPageNumber
// Return: (void)
- (void) updateBookInfo: (NSString *) bookPath :(NSInteger) currentReadPageNumber;

@end
