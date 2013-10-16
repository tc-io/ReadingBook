//
//  PDFViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-16.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFView.h"

@interface PDFViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    IBOutlet PDFView *pdfView;
    NSString *pdfName;
    NSString *pdfPath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil filePath:(NSString*)fPath fileName:(NSString*)fName;

@end
