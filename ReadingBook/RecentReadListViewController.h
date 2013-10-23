//
//  RecentReadListViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-19.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentReadListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *recentReadBookInfo;   // store the book’s path
@property (strong, nonatomic)UIImage *bookDisplayImage; // the book display image

- (void) addBookInfoToDictionary:(NSString*)bookPath;

@end
