//
//  PDFViewer.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-7.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PDFView.h"

@implementation PDFView

@synthesize pdf;
@synthesize page;
@synthesize currentPageNumber;
@synthesize filePath;

- (id)initWithFrame:(CGRect)frame :(NSString *)fPath :(int)curPageNum
{
    NSLog(@"[PDFView.initWithFrame] filePath: %@, currentPageNumber: %d",fPath,curPageNum);
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor blueColor];
        self.filePath = fPath;
        self.currentPageNumber = curPageNum;
        self.page = CGPDFDocumentGetPage([self getPDFRefWithFilePath:self.filePath], self.currentPageNumber);
    }
    return self;
}

- (CGPDFDocumentRef)getPDFRefWithFilePath:(NSString *)aFilePath
{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    
    path = CFStringCreateWithCString(NULL, [aFilePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    
    document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    
    int totalPages = CGPDFDocumentGetNumberOfPages(document);
    if (totalPages == 0) {
        return NULL;
    }
    return document;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"[PDFView.drawRect] filePath: %@, CurrentPageNumber: %d",self.filePath,self.currentPageNumber);
    
    //得到绘图上下文环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //得到一个PDF页面
    //page = CGPDFDocumentGetPage(pdf, self.currentPage);
    
    //坐标转换，Quartz的坐标系统是以左下角为起始点，但iPhone视图以左上角为起点
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    //坐标系转换
    CGContextScaleCTM(context, 1.0, -1);
    //pdf文档适配屏幕大小
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(self.page, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, page);
}

- (void)reloadView
{
    [super setNeedsDisplay];
}

//- (void)goUpPage
//{
//    if (currentPage<2)
//        return;
//    --currentPage;
//    [self reloadView];
//}
//
//- (void)goDownPage
//{
//    if (currentPage >= totalPages)
//        return;
//    ++currentPage;
//    [self reloadView];
//}
//
//- (void) jumpToPageByNumber:(int)gotoNumber
//{
//    if (gotoNumber<1 || gotoNumber>totalPages)
//        return;
//    currentPage = gotoNumber;
//    [self reloadView];
//}

@end