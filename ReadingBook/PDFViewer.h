//
//  PDFViewer.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-7.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewer : UIView
{
    CGPDFDocumentRef pdf;
}

-(void) drawInContext:(CGContextRef)context;

@end
