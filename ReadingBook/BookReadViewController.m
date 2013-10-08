//
//  BookReadViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-2.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "BookReadViewController.h"

@implementation BookReadViewController

@synthesize webView;
@synthesize dataObject;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [webView loadHTMLString:dataObject baseURL:[NSURL URLWithString:@""]];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    BOOL navBarStat = [self.navigationController isNavigationBarHidden];
//    NSLog(@"BookReadViewControler-->%d",navBarStat);
//    [self.navigationController setNavigationBarHidden:!navBarStat animated:YES];
//}
//
//- (IBAction)handleTapGesture:(UIGestureRecognizer *)sender
//{
//    CGPoint tapPoint = [sender locationInView:self.webView];
//    int tapX = (int) tapPoint.x;
//    int tapY = (int) tapPoint.y;
//    NSLog(@"x-> %d, y-> %d",tapX,tapY);
//}
@end
