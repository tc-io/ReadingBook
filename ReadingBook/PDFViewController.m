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
@synthesize dataObject;
@synthesize currentPage;

- (id)initWithPdfPathAndPageNumber:(NSString *)filePath pageNumber:(int)curPageNum{
    if (self = [super init]) {
        self.filePath = filePath;
        self.currentPage = curPageNum;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"file Path %@, %d",self.filePath, self.currentPage);
    self.pdfView.pdf = [self.pdfView getPDFRefWithFilePath:self.filePath];
    self.pdfView.currentPage = self.currentPage;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
