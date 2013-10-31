//
//  PageModelViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-17.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PageModelViewController.h"

@implementation PageModelViewController

@synthesize pageController;
@synthesize pageContent;
@synthesize totalPages;
@synthesize filePath;


-(CGPDFDocumentRef) MyGetPDFDocumentRef: (const char *)filename
{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    document = CGPDFDocumentCreateWithURL (url);
    CFRelease(url);
    int   count = CGPDFDocumentGetNumberOfPages (document);
    if (count == 0) {
        printf("`%s' needs at least one page!", filename);
        return NULL;
    }
    return document;
}

//stackoverflow.com/questions/6531889/rotating-pdf-document-shrinks-after-a-while
-(void) MyCreatePDFFile :(CGRect)pageRect :(const char *)filename
{
    
    CFStringRef path;
    CFURLRef url;
    CFMutableDictionaryRef myDictionary = NULL;
    
    path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path,
                                         kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    myDictionary = CFDictionaryCreateMutable(NULL, 0,
                                             &kCFTypeDictionaryKeyCallBacks,
                                             &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
    CGContextRef pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    CGContextBeginPage (pdfContext, &pageRect);
    [self myDrawContent:pdfContext];
    CGContextEndPage (pdfContext);
    CGContextRelease (pdfContext);
}

-(void) MyDrawPDFPageInRect:(CGContextRef)context :(CGPDFPageRef)page :(CGPDFBox)box :(CGRect)rect :(int)rotation :(bool)preserveAspectRatio
{
    //////// this is rotating code of PDF ///
    CGAffineTransform m;
    m = CGPDFPageGetDrawingTransform (page, box, rect, rotation, preserveAspectRatio);
    CGContextSaveGState (context);
    CGContextConcatCTM (context, m);
    CGRect pageframe = CGPDFPageGetBoxRect (page, box);
    CGContextClipToRect (context,pageframe);
    CGContextDrawPDFPage (context, page);
    CGContextRestoreGState (context);
}

-(void)myDrawContent:(CGContextRef )context
{
    CGPDFDocumentRef pdfDoc = [self MyGetPDFDocumentRef:"/Users/Jeff/Library/Application Support/iPhone Simulator/7.0.3/Applications/9262BEE0-FF1B-4181-9351-CD0EF00ADB2B/Documents/1.txt"];
    
    int noOfPages = CGPDFDocumentGetNumberOfPages(pdfDoc);
    
    CGRect pageRect = CGRectMake(0, 0, 612, 792);
    for( int i = 1 ; i <= noOfPages ; i++ )
    {
        CGPDFPageRef page = CGPDFDocumentGetPage (pdfDoc, i);
        //pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        //[self MyDisplayPDFPage:pdfContext :i :[fileLoc UTF8String]];
        [self MyDrawPDFPageInRect:context :page :kCGPDFMediaBox :pageRect :40 :true];
    }
    
}


- (void) createPDFFilewithFilePath:(CGRect) pageRect :(const char *)filePath
{
    NSLog(@"createPDFFilewithFilePath");
    NSString *pth = @"/Users/Jeff/Library/Application Support/iPhone Simulator/7.0.3/Applications/9262BEE0-FF1B-4181-9351-CD0EF00ADB2B/Documents/1.pdf";
    const char *pdfFilePath = [pth UTF8String];
    
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    path = CFStringCreateWithCString(NULL, pdfFilePath, kCFStringEncodingUTF8);
    url =CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    NSLog(@"URL ->%@",url);
    CFRelease(path);
    myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("CreatedPDF"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("JK_Reader"));
    
    pdfContext = CGPDFContextCreateWithURL(url, &pageRect, myDictionary);
    NSLog(@"Done Creating PDF Context");
    CFRelease(myDictionary);
    CFRelease(url);

    pageDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    boxData = CFDataCreate(NULL, (const UInt8 *)&pageRect, sizeof(CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage(pdfContext, pageDictionary);
    //[self myDrawContent:pdfContext :filePath];
    CGPDFContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
    CFRelease(pageDictionary);
    CFRelease(boxData);
}


- (void)createContentPage
{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    
    path = CFStringCreateWithCString(NULL, [self.filePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    
    document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    totalPages = CGPDFDocumentGetNumberOfPages(document);
    CFRelease(document);
    
    pageContent = [[NSMutableArray alloc] init];
    for (int i=0; i<totalPages;i++) {
        [pageContent addObject:[NSValue value:&i withObjCType:@encode(int)]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createContentPage];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
    PDFViewController *pdfViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:pdfViewController];
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:Nil];
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
}

- (id) initWithFilePath: (NSString *)fPath
{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        self.filePath = fPath;
        [self MyCreatePDFFile:self.view.frame :"Users/Jeff/Library/Application Support/iPhone Simulator/7.0.3/Applications/9262BEE0-FF1B-4181-9351-CD0EF00ADB2B/Documents/1.txt"];

    }
    return self;
}

- (PDFViewController *) viewControllerAtIndex:(NSInteger)index
{
    NSLog(@"PageModelViewController->PDF Path %@, index->%d",self.filePath,index);
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return Nil;
    }
    PDFViewController * dataViewController = [[PDFViewController alloc] initWithNibName:@"PDFViewController" bundle:Nil filePath:self.filePath pageNumber:index+1];
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
    return dataViewController;
}

- (NSUInteger) indexOfViewController:(PDFViewController*)viewController
{
    return [self.pageContent indexOfObject:viewController.dataObject];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PDFViewController*)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return Nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PDFViewController*)viewController];
    if (index == NSNotFound) {
        return Nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return Nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
