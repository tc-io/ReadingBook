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
@synthesize pdf;

- (id)initWithFilePathAndCurPageNumber:(NSString *)fPath :(int)curPageNum{
    if (self = [super init]) {
        self.filePath = fPath;
        self.currentPageNumber = curPageNum;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pdfView = [[PDFView alloc] initWithFrame:self.view.frame];
    //NSLog(@"[viewWillAppear] PDF->%@, Page->%@", self.pdfView.pdf, self.pdfView.page);
    //    self.pdfView = [[PDFView alloc]initWithFrame:self.view.frame :self.filePath :self.currentPageNumber];
    self.pdf = [self.pdfView getPDFRefWithFilePath:self.filePath];
    self.pdfView.page = CGPDFDocumentGetPage(pdf, self.currentPageNumber);
    NSLog(@"[PDFViewController.viewDidLoad] DidLoad pdfView.page-> %@", self.pdfView.page);
    //    self.pdfView.currentPage = self.currentPage;
    [self.view addSubview:self.pdfView];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    NSLog(@"[PDFViewController.viewDidDisappear] Release pdfView.page-> %@", self.pdfView.page);
//    CFRelease(self.pdfView.page);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    CFRelease(self.pdf);
}

@end
