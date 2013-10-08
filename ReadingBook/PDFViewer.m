//
//  PDFViewer.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-7.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PDFViewer.h"

@implementation PDFViewer

- (void)drawInContext:(CGContextRef)context :(size_t)pageNumber
{
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, pageNumber);
    
    CGContextSaveGState(context);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context,pdfTransform);
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
}


- (CGPDFDocumentRef) getPDFDocumentRef:(const char *)fileName
{
    CFStringRef path = CFStringCreateWithCString(NULL, fileName, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(url);
    size_t count = CGPDFDocumentGetNumberOfPages(document);
    if (count == 0) {
        NSLog(@"there is no page in file <%s>",fileName);
        return NULL;
    }
    CFRelease(path);
    CFRelease(url);
    return document;
}

- (void) displayPDFPage:(CGContextRef) pdfContext:(size_t) pageNumber:(const char *)fileName
{
    CGPDFDocumentRef document = [self getPDFDocumentRef:fileName];
    CGPDFPageRef page = CGPDFDocumentGetPage(document, pageNumber);
    CGContextDrawPDFPage(pdfContext, page);
    CGPDFDocumentRelease(document);
}

- (void) createPDFFile:(CGRect) pageRect:(const char *)fileName
{
    CFStringRef path = CFStringCreateWithCString(NULL, fileName, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    CFMutableDictionaryRef myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("MY PDF File"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
    CGContextRef pdfContext = CGPDFContextCreateWithURL(url, &pageRect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    
    CFMutableDictionaryRef pageDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDataRef boxData = CFDataCreate(NULL, (const UInt8 *)&pageRect, sizeof(pageRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage(pdfContext, pageDictionary);
    CGPDFContextEndPage(pdfContext);
    
    [self drawInContext:pdfContext];
    NSLog(@"Creat PDF Context->%@",pdfContext);
    CGContextRelease(pdfContext);
    CFRelease(pageDictionary);
    CFRelease(boxData);

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CFStringRef path = CFStringCreateWithCString(NULL, "/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/3.pdf", kCFStringEncodingUTF8);
        CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
        NSLog(@"URL->%@",url);
        CFRelease(path);
        pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
        CFRelease(url);
        
//        [self createPDFFile:self.frame :"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/3.txt"];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"123");
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawInContext:UIGraphicsGetCurrentContext():98];
    NSLog(@"Current Context->%@",UIGraphicsGetCurrentContext());
}

@end
