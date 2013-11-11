//
//  PageModelViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-17.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PageViewController_Model.h"

@implementation PageViewController_Model

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

        [self getBookAllPages];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        tapGesture.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tapGesture];
    }
    return self;
}


- (void) getBookAllPages
{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    path = CFStringCreateWithCString(NULL, [self.filePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    document = CGPDFDocumentCreateWithURL(url);
    self.totalPages = CGPDFDocumentGetNumberOfPages(document);
    CFRelease(document);
    CFRelease(url);
    CFRelease(path);
    NSLog(@"[PageViewController_Model.getBookAllPages]self.totalPages %d",self.totalPages);
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
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageController.dataSource = self;
    
    PDFViewController *pdfViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    self.allPageViewController = [NSMutableArray arrayWithObject:pdfViewController];
    [self.pageController setViewControllers:self.allPageViewController direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:Nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
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
        NSLog(@"[PageViewController_Model.viewControllerBeforeViewController] curPageNumber is the Min: <%d>",self.currentPageNumber);
        return Nil;
    }
    self.currentPageNumber--;
    NSLog(@"[PageViewController_Model.viewControllerBeforeViewController] curPageNumber: <%d>",self.currentPageNumber);
    PDFViewController *beforeViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    [self.allPageViewController removeObjectAtIndex:0];
    [self.allPageViewController addObject:beforeViewController];
    return [self.allPageViewController objectAtIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.currentPageNumber++;
    if (self.currentPageNumber > self.totalPages) {
        NSLog(@"[PageViewController_Model.viewControllerAfterViewController] curPageNumber is out of total pages: <%d> > <%d>",self.currentPageNumber,self.totalPages);
        return Nil;
    }
    NSLog(@"[PageViewController_Model.viewControllerAfterViewController] curPageNumber: <%d>",self.currentPageNumber);
    PDFViewController *afterViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    [self.allPageViewController removeObjectAtIndex:0];
    [self.allPageViewController addObject:afterViewController];
    return [self.allPageViewController objectAtIndex:0];
}

- (void)nextPage
{
    self.currentPageNumber++;
    if (self.currentPageNumber > self.totalPages) {
        NSLog(@"[PageViewController_Model.nextPage] curPageNumber is out of total pages: <%d> > <%d>",self.currentPageNumber,self.totalPages);
        self.pageTimer = nil;
        return;
    }
    NSLog(@"[PageViewController_Model.nextPage] curPageNumber: <%d>",self.currentPageNumber);
    PDFViewController *afterViewController = [[PDFViewController alloc] initWithFilePathAndCurPageNumber:self.filePath :self.currentPageNumber];
    [self.allPageViewController removeObjectAtIndex:0];
    [self.allPageViewController addObject:afterViewController];
    [self.pageController setViewControllers:self.allPageViewController direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:Nil];
}

- (void) singleTapAction:(id)sender
{
    BOOL isHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!isHidden animated:YES];
    self.pageController.view.frame = self.view.frame;
    NSLog(@"[PageViewController_Model] %f,%f",self.view.frame.size.width,self.view.frame.size.height);
//    [self reloadInputViews];
}


@end