//
//  PageViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-11-14.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PageViewController.h"

@implementation PageViewController

-(id)initWithPDFAtPath:(NSString *)path {
    NSURL *pdfUrl = [NSURL fileURLWithPath:path];
    PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfUrl);
    totalPages = (int)CGPDFDocumentGetNumberOfPages(PDFDocument);
    bookPath = path;
    self = [super initWithNibName:nil bundle:nil];
    UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dobuleTapAction:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    return self;
}

- (void) dobuleTapAction:(id)sender {
    BOOL isHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!isHidden animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    BOOL isHidden = self.navigationController.navigationBarHidden;
    if (!isHidden)
        [self.navigationController setNavigationBarHidden:!isHidden animated:YES];

    contentViewController = [[ContentViewController alloc] initWithPDF:PDFDocument];
    currentIndex = [modelArray indexOfObject:[(ContentViewController *)viewController page]];
    if (currentIndex == 0)
        return nil;

    contentViewController.page = [modelArray objectAtIndex:currentIndex - 1];
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    BOOL isHidden = self.navigationController.navigationBarHidden;
    if (!isHidden)
        [self.navigationController setNavigationBarHidden:!isHidden animated:YES];
    
    contentViewController = [[ContentViewController alloc] initWithPDF:PDFDocument];
    //get the current page
    currentIndex = [modelArray indexOfObject:[(ContentViewController *)viewController page]];
    //detect if last page
    //remember that in an array, the first index is 0
    //so if there are three pages, the array will contain the following pages: 0, 1, 2
    //page 2 is the last page, so 3 - 1 = 2 (totalPages - 1 = last page)
    if (currentIndex == totalPages - 1)
        return nil;
    
    contentViewController.page = [modelArray objectAtIndex:currentIndex + 1];
    return contentViewController;
}

#pragma mark - UIPageViewControllerDelegate Methods
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = [thePageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [thePageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    thePageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //modelArray holds the page numbers
    modelArray = [[NSMutableArray alloc] init];
    for (int index = 1; index <= totalPages; index++)
        [modelArray addObject:[NSString stringWithFormat:@"%i", index]];
        
    thePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:nil];
    thePageViewController.delegate = self;
    thePageViewController.dataSource = self;
    thePageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    contentViewController = [[ContentViewController alloc] initWithPDF:PDFDocument];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *recentReadBookInfoPlistPath = [path stringByAppendingPathComponent:@"RecentReadBookInfo.plist"];
    NSMutableDictionary *recentReadBookInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:recentReadBookInfoPlistPath];
    currentIndex = [[recentReadBookInfo valueForKey:bookPath] integerValue];
    contentViewController.page = [modelArray objectAtIndex:currentIndex+1];
    NSArray *viewControllers = [NSArray arrayWithObject:contentViewController];
    [thePageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:thePageViewController];
    [self.view addSubview:thePageViewController.view];
    [thePageViewController didMoveToParentViewController:self];
}

-(void)dealloc {
    contentViewController = nil;
    modelArray = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    contentViewController = nil;
    modelArray = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *recentReadBookInfoPlistPath = [path stringByAppendingPathComponent:@"RecentReadBookInfo.plist"];
    NSMutableDictionary *recentReadBookInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:recentReadBookInfoPlistPath];
    NSString *currentReadPageNumString = [NSString stringWithFormat:@"%d", currentIndex];
    [recentReadBookInfo setValue:currentReadPageNumString forKey:bookPath];
    [recentReadBookInfo writeToFile:recentReadBookInfoPlistPath atomically:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
