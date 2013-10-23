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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil filePath:(NSString*)fPath pageNumber:(int)curPageNum
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filePath = fPath;
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
