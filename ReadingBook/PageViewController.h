//
//  PageViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-11-14.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@class ContentViewController, UIPrintInteractionController;

@interface PageViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
    UIPageViewController *thePageViewController;
    ContentViewController *contentViewController;
    NSMutableArray *modelArray;
    CGPDFDocumentRef PDFDocument;
    NSString *bookPath;
    int currentIndex;
    int totalPages;
}

-(id)initWithPDFAtPath:(NSString *)path;

@end