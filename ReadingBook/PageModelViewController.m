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
@synthesize allPageViewController;

@synthesize totalPages;
@synthesize filePath;
@synthesize currentReadNumber;
@synthesize pageTimer;

- (void)createPageViewControllerArray
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
    
    self.allPageViewController = [[NSMutableArray alloc] init];
    for (int i=0; i<totalPages;i++) {
//        PDFViewController * dataViewController = [[PDFViewController alloc] initWithNibName:@"PDFViewController" bundle:Nil filePath:self.filePath pageNumber:i+1];
        PDFViewController * dataViewController = [[PDFViewController alloc] initWithPdfPathAndPageNumber:self.filePath pageNumber:i+1];
        dataViewController.dataObject = [NSValue value:&i withObjCType:@encode(int)];
        [self.allPageViewController addObject:dataViewController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createPageViewControllerArray];
    
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
    self.pageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

- (id) initWithFilePath: (NSString *)fPath
{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        self.filePath = [[NSString alloc]initWithString:fPath];
        self.currentReadNumber = 1;
        //[self MyCreatePDFFile:self.view.frame :"Users/Jeff/Library/Application Support/iPhone Simulator/7.0.3/Applications/9262BEE0-FF1B-4181-9351-CD0EF00ADB2B/Documents/1.txt"];
        //[self createPDF];

    }
    return self;
}

- (PDFViewController *) viewControllerAtIndex:(NSInteger)index
{
    return [self.allPageViewController objectAtIndex:index];
}

- (NSUInteger) indexOfViewController:(PDFViewController*)viewController
{
    return currentReadNumber;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentReadNumber <= 1) {
        return Nil;
    }
    self.currentReadNumber--;
    NSLog(@"[PageModelViewController.viewControllerAfterViewController] current read number is <%d>",self.currentReadNumber);
    return [self.allPageViewController objectAtIndex:self.currentReadNumber];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.currentReadNumber++;
    NSLog(@"[PageModelViewController.viewControllerAfterViewController] current read number is <%d>",self.currentReadNumber);
    if (self.currentReadNumber >= [self.allPageViewController count]) {
        return Nil;
    }
    return [self.allPageViewController objectAtIndex:self.currentReadNumber];
}

- (void)nextPage
{
 //   [self.pageController setViewControllers:self.allPageViewController direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:Nil];
}

@end
