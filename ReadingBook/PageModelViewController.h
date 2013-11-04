//
//  PageModelViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-17.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFViewController.h"

@interface PageModelViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *allPageViewController;

@property NSString *filePath;   // 文件路径
@property int currentPageNumber;    //当前阅读页
@property (nonatomic, strong) NSTimer * pageTimer;

- (id) initWithFilePathAndCurPageNumber: (NSString *)fPath :(int)curPageNum;

@end
