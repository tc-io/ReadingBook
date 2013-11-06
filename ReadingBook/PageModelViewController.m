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
@synthesize filePath;
@synthesize currentPageNumber;
@synthesize pageTimer;
@synthesize autoFlipSpeed;
@synthesize totalPages;

- (id) initWithFilePathAndCurPageNumber: (NSString *)fPath :(int)curPageNum
{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        self.filePath = [[NSString alloc]initWithString:fPath];
        self.currentPageNumber = curPageNum;
        //[self MyCreatePDFFile:self.view.frame :"Users/Jeff/Library/Application Support/iPhone Simulator/7.0.3/Applications/9262BEE0-FF1B-4181-9351-CD0EF00ADB2B/Documents/1.txt"];
        //[self createPDF];
    }
    return self;
}


- (void)getAllPagesViewControllerToArray
{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    
    path = CFStringCreateWithCString(NULL, [self.filePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    
    document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    self.totalPages = CGPDFDocumentGetNumberOfPages(document);
    CFRelease(document);
    
    //    self.allPageViewController = [[NSMutableArray alloc] init];
    //    for (int i=0; i<totalPages;i++) {
    ////        PDFViewController * dataViewController = [[PDFViewController alloc] initWithNibName:@"PDFViewController" bundle:Nil filePath:self.filePath pageNumber:i+1];
    //        PDFViewController * dataViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :i+1];
    //        [self.allPageViewController addObject:dataViewController];
    //    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self getAllPagesViewControllerToArray];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
    PDFViewController *pdfViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    NSLog(@"pdfview controller %@",pdfViewController);
    self.allPageViewController = [NSMutableArray arrayWithObject:pdfViewController];
    [pageController setViewControllers:self.allPageViewController direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:Nil];
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
//    self.pageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

//- (PDFViewController *) viewControllerAtIndex:(NSInteger)index
//{
//    return [self.allPageViewController objectAtIndex:index];
//}

//- (NSUInteger) indexOfViewController:(PDFViewController*)viewController
//{
//    return currentPageNumber;
//}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPageNumber <= 1) {
        NSLog(@"[PageModelViewController.viewControllerAfterViewController] curPageNumber is the Min <%d>",self.currentPageNumber);
        return Nil;
    }
    self.currentPageNumber--;
    NSLog(@"[PageModelViewController.viewControllerAfterViewController] curPageNumber: <%d>",self.currentPageNumber);
    PDFViewController *beforeViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    [self.allPageViewController removeObjectAtIndex:0];
    [self.allPageViewController addObject:beforeViewController];
    return [self.allPageViewController objectAtIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.currentPageNumber++;
    if (self.currentPageNumber > self.totalPages) {
        NSLog(@"[PageModelViewController.viewControllerAfterViewController] curPageNumber is out of total pages: <%d> > <%d>",self.currentPageNumber,self.totalPages);
        return Nil;
    }
    NSLog(@"[PageModelViewController.viewControllerAfterViewController] curPageNumber: <%d>",self.currentPageNumber);
    PDFViewController *afterViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    [self.allPageViewController removeObjectAtIndex:0];
    [self.allPageViewController addObject:afterViewController];
    return [self.allPageViewController objectAtIndex:0];
}

- (void)nextPage
{
    self.currentPageNumber++;
    if (self.currentPageNumber > self.totalPages) {
        NSLog(@"[PageModelViewController.viewControllerAfterViewController] curPageNumber is out of total pages: <%d> > <%d>",self.currentPageNumber,self.totalPages);
        self.pageTimer = nil;
        return;
    }
    NSLog(@"[PageModelViewController.viewControllerAfterViewController] curPageNumber: <%d>",self.currentPageNumber);
    PDFViewController *afterViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    [self.allPageViewController removeObjectAtIndex:0];
    [self.allPageViewController addObject:afterViewController];
    [self.pageController setViewControllers:self.allPageViewController direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:Nil];
}

@end