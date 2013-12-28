//
//  FontColorSecectActionSheet.m
//  ReadingBook
//
//  Created by Jeff.King on 13-10-13.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "FontColorSecectActionSheet.h"

@implementation CustomActionSheet

@synthesize view;
@synthesize toolBar;

-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title
{
    self = [super init];
    if (self)
    {
        int theight = height - 40;
        int btnnum = theight/50;
        for(int i=0; i<btnnum; i++)
        {
            [self addButtonWithTitle:@" "];
        }
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        
        UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:nil
                                                                       action:nil];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(done)];
        
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(docancel)];
        
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,titleButton,fixedButton,rightButton,nil];
        [toolBar setItems: array];
        [self addSubview:toolBar];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, height-44)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
    }
    return self;
}

-(void)done
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)docancel
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end