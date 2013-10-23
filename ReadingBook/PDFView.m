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
@synthesize totalPages;
@synthesize currentPage;

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)fPath
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void) createPDFFilewithFilePaht:(CGRect) pageRect :(const char *)filePath
{
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    path = CFStringCreateWithCString(NULL, filePath, kCFStringEncodingUTF8);
    url =CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("CreatedPDF"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("JK_Reader"));
    pdfContext = CGPDFContextCreateWithURL(url, &pageRect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    pageDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    boxData = CFDataCreate(NULL, (const UInt8 *)&pageRect, sizeof(CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage(pdfContext, pageDictionary);
    //myDrawContent(pdfContext)
    CGPDFContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
    CFRelease(pageDictionary);
    CFRelease(boxData);
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
    
    totalPages = CGPDFDocumentGetNumberOfPages(document);
    currentPage = 1;
    if (totalPages == 0) {
        return NULL;
    }
    return document;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"PDFView Draw Rect ->%@, CurrentPageNumber -> %d",self.pdf,self.currentPage);
    
    //得到绘图上下文环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //得到一个PDF页面
    page = CGPDFDocumentGetPage(pdf, self.currentPage);
    //坐标转换，Quartz的坐标系统是以左下角为起始点，但iPhone视图以左上角为起点
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    //坐标系转换
    CGContextScaleCTM(context, 1.0, -1);
    //pdf文档适配屏幕大小
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, page);
}

- (void)reloadView
{
    [super setNeedsDisplay];
}

- (void)goUpPage
{
    if (currentPage<2)
        return;
    --currentPage;
    [self reloadView];
}

- (void)goDownPage
{
    if (currentPage >= totalPages)
        return;
    ++currentPage;
    [self reloadView];
}

- (void) jumpToPageByNumber:(int)gotoNumber
{
    if (gotoNumber<1 || gotoNumber>totalPages)
        return;
    currentPage = gotoNumber;
    [self reloadView];
}

@end