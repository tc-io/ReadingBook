//
//  PageViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-4.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#define kFontSizeId @"FontSizeId"
#define kAutoReadId @"AutoRead"
#define kAutoSpeedId @"AutoSpeed"

#import "TxtViewController.h"

@interface TxtViewController()

@property (nonatomic, copy) NSString * bookName;
@property (nonatomic, copy) NSString * bookPath;
@property (nonatomic, copy) NSString * bookContent;
@property (nonatomic, strong) NSUserDefaults * userDefault;

@property (nonatomic, strong) UITextView * textView;

@property (nonatomic, assign) BOOL autoPage;
@property (nonatomic, strong) NSTimer * pageTimer;

@property (nonatomic, assign) BOOL visible;  //判断是隐藏还是出现

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat autoSpeed;

@property (nonatomic, strong) UIBarButtonItem * configBarButton;

//@property (nonatomic, strong) SNPopupView * popupView;
//@property (nonatomic, assign) BOOL popupVisible;
//@property (nonatomic, strong) UIView * configView;
//@property (nonatomic, strong) UILabel * fontLabel;
//@property (nonatomic, strong) UISwitch * autoPageSwitch;
//@property (nonatomic, strong) UISlider * fontSizeSlider;
//@property (nonatomic, strong) UILabel * speedLabel;
//@property (nonatomic, strong) UISlider * speedSlider;

- (void) prevPage;
- (void) nextPage;

@end

@implementation TxtViewController

- (id) initWithBookName:(NSString *)bookName :(NSString *)bookPath
{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        self.bookName = bookName;
        self.bookPath = bookPath;
        self.fontSize = 14.0f;
        self.autoPage = NO;
        //self.popupVisible = NO;
        
        self.userDefault = [NSUserDefaults standardUserDefaults];
        if ([self.userDefault objectForKey:kFontSizeId]) {
            self.fontSize = [[self.userDefault objectForKey:kFontSizeId] floatValue];
        }
        
        if ([self.userDefault objectForKey:kAutoSpeedId]) {
            self.autoSpeed = [[self.userDefault objectForKey:kAutoSpeedId] floatValue];
        } else {
            self.autoSpeed = 1.0f;
        }
        
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    
    // Get Txt Book's Content
    NSString *bookPath = [NSString stringWithFormat:@"%@/%@",self.bookPath,self.bookName];
    NSLog(@"%@",bookPath);
    self.bookContent = [[NSString alloc]initWithContentsOfFile:bookPath encoding:NSUTF8StringEncoding error:NULL];
    if (!self.bookContent) {
        self.bookContent = [NSString stringWithContentsOfFile:bookPath encoding:NSASCIIStringEncoding error:NULL];
    }
    if (!self.bookContent) {
        self.bookContent = [NSString stringWithContentsOfFile:bookPath encoding:NSUTF16StringEncoding error:NULL];
    }
    if (!(self.bookContent.length > 0)) {
        NSLog(@"Empy Book");
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.bookName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    //左右滑动的手势
    
    UISwipeGestureRecognizer * swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer * swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    if ([self.bookName hasSuffix:@"txt"]) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.textView.editable = NO;
        self.textView.text = self.bookContent;
        self.textView.font = [UIFont systemFontOfSize:self.fontSize];
        [self.textView addGestureRecognizer:tapGesture];
        [self.textView addGestureRecognizer:swipeLeftGesture];
        [self.textView addGestureRecognizer:swipeRightGesture];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.textView];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.pageTimer invalidate];
    self.pageTimer = nil;
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
}

- (void) prevPage {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    CGPoint offset = self.textView.contentOffset;
    CGSize viewSize = self.textView.frame.size;
    
    offset.y -= viewSize.height - self.fontSize;
    if (offset.y < 0) {
        offset.y = 0;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.textView cache:YES];
    }
    [UIView commitAnimations];
    
    self.textView.contentOffset = offset;
}
- (void) nextPage {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    CGPoint offset = self.textView.contentOffset;
    CGSize viewSize = self.textView.frame.size;
    CGSize contentSize = self.textView.contentSize;
    offset.y += viewSize.height - self.fontSize;
    if (offset.y > (contentSize.height - viewSize.height)) {
        offset.y = contentSize.height - viewSize.height;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.textView cache:YES];
    }
    
    [UIView commitAnimations];
    self.textView.contentOffset = offset;
}

- (void) singleTapAction:(id)sender {
    //判断导航栏和toolbar是隐藏还是显示
    if(!self.visible) {
        self.visible = YES;
        [self.navigationController setNavigationBarHidden:self.visible animated:YES];
    } else {
        self.visible = NO;
        [self.navigationController setNavigationBarHidden:self.visible animated:YES];
    }
}

- (void) swipeGestureAction:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextPage];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self prevPage];
    }
}

- (void) readConfigFinished {
    self.fontSize = (int) 10;
    self.textView.font = [UIFont systemFontOfSize:self.fontSize];
    
    [self.userDefault setValue:@(self.fontSize) forKey:kFontSizeId];
    self.autoPage = YES;
    self.autoSpeed = 12.0f;
    [self.userDefault setValue:@(self.autoSpeed) forKey:kAutoSpeedId];
    [self.userDefault synchronize];
    
    if (self.autoPage) {
        self.pageTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoSpeed target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    } else {
        [self.pageTimer invalidate];
        self.pageTimer = nil;
    }
}

@end
