//
//  PDFViewer.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-7.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PDFView.h"

@implementation PDFView

@synthesize page;
@synthesize currentPageNumber;
@synthesize pdf;


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
    }
    return self;
}

- (void)CreatePDFFile:(CGRect)pageRect :(const char *)fileName
{
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFMutableDictionaryRef myDict = NULL;
    
    path = CFStringCreateWithCString(NULL, fileName, kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    
    myDict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDict, kCGPDFContextTitle, CFSTR("My PDF File"));
    CFDictionarySetValue(myDict, kCGPDFContextCreator, CFSTR("JKReader"));
    pdfContext = CGPDFContextCreateWithURL(url, &pageRect, myDict);
    CFRelease(myDict);
    CFRelease(url);
    
    CGContextBeginPage(pdfContext, &pageRect);
    
//    CGContextStrokeRect(pdfContext, CGRectMake(50, 50, pageRect.size.width-100, pageRect.size.height-100));
//    const char *picture = "/Users/Jeff/Desktop/CountryPicker/Flags/AC.png";
//    CGImageRef image;
//    CGDataProviderRef provider;
//    CFStringRef picturePath;
//    CFURLRef pictureURL;
//    picturePath = CFStringCreateWithCString(NULL, picture, kCFStringEncodingUTF8);
//    pictureURL = CFURLCreateWithFileSystemPath(NULL, picturePath, kCFURLPOSIXPathStyle, 0);
//    CFRelease(picturePath);
//    provider = CGDataProviderCreateWithURL(pictureURL);
//    CFRelease(pictureURL);
//    image = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
//    CGDataProviderRelease(provider);
//    CGContextDrawImage(pdfContext, CGRectMake(0, 0, 48, 48), image);
//    CGImageRelease(image);
    
    
    CGContextSetTextDrawingMode(pdfContext, kCGTextFill);
    CGContextSetRGBFillColor(pdfContext, 0, 0, 0, 1);
    NSString *text = @"Hello World";
    UIFont *font = [UIFont systemFontOfSize:14.0];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:font,NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName,nil];
    
//    [text drawAtPoint:CGPointMake(120, 120) withAttributes:dict];
    [text drawInRect:self.frame withAttributes:dict];
    [text drawAtPoint:CGPointMake(120, 120) withAttributes:dict];
//    CGContextShowTextAtPoint(pdfContext, 260, 390, text, strlen(text));
    
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
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
    
    [self CreatePDFFile:self.frame :"/Users/Jeff/Library/Application Support/iPhone Simulator/7.0.3/Applications/DF699FEC-EABA-455C-BD0B-3EA8D1D530D2/Documents/text.pdf"];
    return document;
}

- (void)drawRect:(CGRect)rect
{
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

@end