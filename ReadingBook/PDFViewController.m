//
//  PDFViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-16.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PDFViewController.h"

@implementation PDFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil filePath:(NSString*)fPath fileName:(NSString*)fName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pdfPath = fPath;
        pdfName = fName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *pdfFullPath = [[NSString alloc]initWithFormat:@"%@/%@",pdfPath,pdfName];
    pdfView = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) filePath:pdfFullPath];
    [self.view addSubview:pdfView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [pdfView goDownPage];
}

@end
