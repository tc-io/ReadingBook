//
//  PickupColorViewController.h
//  ReadingBook
//
//  Created by Jeff.King on 12/23/13.
//  Copyright (c) 2013 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickupColorViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, retain) NSArray *colorsArray;
@property(nonatomic, strong) UIPickerView *colorsPickView;

@end
