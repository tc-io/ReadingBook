//
//  PageViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-4.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "PageViewController.h"
//#import "PDFViewer.h"

@implementation PageViewController

@synthesize pageController;
@synthesize pageContent;

-(void) createContentPages
{
    NSMutableArray *pageStrings = [[NSMutableArray alloc]init];
    for (int i = 1; i< 3; i++) {
        NSString *contentString = [[NSString alloc] initWithFormat:@"<Html><body><p>Content %d</p></body></html>",i];
        [pageStrings addObject:contentString];
        NSLog(@"%@",contentString);
    }
    pageContent = [[NSArray alloc] initWithArray:pageStrings];
}

-(BookReadViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index
    
    // By checking to see if the requested page is outside of available page(0 ~ page count) or not
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return Nil;
    }
    
    // Create a new view controller and pass the suitable data
    BookReadViewController *dataViewController = [[BookReadViewController alloc]initWithNibName:@"BookReadViewController" bundle:nil];
    
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
    return dataViewController;
}

-(NSUInteger) indexofViewController:(BookReadViewController *)viewController
{
    // return the index value of the controller
    // by extracting the data object property of the view controller and finding the index of the match element in the pageContent array
    return [self.pageContent indexOfObject:viewController.dataObject];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    // get the view controller which is before the current view controller
    NSUInteger index = [self indexofViewController:(BookReadViewController *)viewController];
    if((index == 0) || (index == NSNotFound)){
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    // get the view controller which is after the current view controller
    NSUInteger index = [self indexofViewController:(BookReadViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createContentPages];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    pageController.dataSource=self;
    [[pageController view]setFrame:[[self view] bounds]];
    
    BookReadViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
    
    NSLog(@"Reading Book =====%@",self.bookName);
    
    //    CGRect frame = CGRectMake(0, 0, 300, 500);
    //    PDFViewer *pdfView = [[PDFViewer alloc] initWithFrame:frame];
    //    pdfView.backgroundColor = [UIColor brownColor];
    //    [self.view addSubview:pdfView];
    
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    //    NSURL *targetURL = [NSURL fileURLWithPath:@"/Users/JK/Library/Application Support/iPhone Simulator/7.0/Applications/5A18296A-823E-4513-B198-0A48BEF1513A/Documents/哈哈.txt"];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    //    [webView loadRequest:request];
    //    [self.view addSubview:webView];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSLog(@"Touch Began");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
