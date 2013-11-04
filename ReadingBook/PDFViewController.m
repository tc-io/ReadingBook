//
//  PDFViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-16.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PDFViewController.h"

@implementation PDFViewController
@synthesize pdfView;
@synthesize currentPageNumber;

- (id)initWithFilePathAndCurPageNumber:(NSString *)fPath :(int)curPageNum{
    if (self = [super init]) {
        self.filePath = fPath;
        self.currentPageNumber = curPageNum;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[PDFViewController.viewWillAppear] filePath: %@, currentPageNumber: %d",self.filePath, self.currentPageNumber);
    self.pdfView = [[PDFView alloc]initWithFrame:self.view.frame :self.filePath :self.currentPageNumber];
//    self.pdfView.pdf = [self.pdfView getPDFRefWithFilePath:self.pdfView.filePath];
//    self.pdfView.currentPage = self.currentPage;
    [self.view addSubview:self.pdfView];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
