//
//  ContentViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-11-14.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PDFScrollView.h"

@class PDFScrollView;

@interface ContentViewController : UIViewController <UIScrollViewDelegate> {
    CGPDFDocumentRef thePDF;
    PDFScrollView *pdfScrollView;
}

-(id)initWithPDF:(CGPDFDocumentRef)pdf;

@property (nonatomic, strong) NSString *page;

@end
