//
//  AppDelegate.h
//  ReadingBook
//
//  Created by Jeff.King on 13-9-30.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) UIWindow *window;
@end
