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
