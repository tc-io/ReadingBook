//
//  BookReadViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-2.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookReadViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) id dataObject;

@end
