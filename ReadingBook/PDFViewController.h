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

@property (strong, nonatomic) IBOutlet PDFView *pdfView;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSString *filePath;
@property int currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil filePath:(NSString*)fPath pageNumber:(int)curPageNum;

@end
