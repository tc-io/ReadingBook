//
//  PDFViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-16.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFView.h"

@interface PDFViewController : UIViewController

@property (strong, nonatomic) PDFView *pdfView;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSString *filePath;
@property int currentPage;

- (id)initWithPdfPathAndPageNumber:(NSString *)filePath pageNumber:(int)curPageNum;

@end
