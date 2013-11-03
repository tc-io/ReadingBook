//
//  BooksListViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-2.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface AllBooksListViewController : PullRefreshTableViewController

@property (strong, nonatomic) NSMutableDictionary *allBooks;
@property (strong, nonatomic)UIImage *bookDisplayImage; // the book display image

- (NSMutableDictionary *) getAllBooksList;   // function: return a dictionary which contain book's path and order by file type

@end
