//
//  PageModelViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-17.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFViewController.h"

@interface PageModelViewController : UIViewController <UIPageViewControllerDataSource>{
    UIPageViewController *pageController;
    NSMutableArray *pageContent;
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *pageContent;

@property int totalPages;// 总共页数
@property NSString *filePath; // 文件路径

- (id) initWithFilePath: (NSString *)fPath;
@end
