//
//  PageViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-4.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//
// Create Data Model For BookRead View Controller

#import <UIKit/UIKit.h>
#import "BookReadViewController.h"

@interface PageViewController : UIViewController <UIPageViewControllerDataSource>
{
    UIPageViewController *pageController;
    NSArray *pageContent;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@property (strong, nonatomic) NSString *bookName;

@end
