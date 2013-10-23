//
//  PageViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-4.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//
// Create Data Model For BookRead View Controller

#import <UIKit/UIKit.h>

@interface TxtViewController : UIViewController

- (id) initWithBookPath:(NSString*)bookPath;


- (void) prevPage;
- (void) nextPage;

@end
