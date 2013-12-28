//
//  PickupColorViewController.m
//  ReadingBook
//
//  Created by Jeff.King on 12/23/13.
//  Copyright (c) 2013 Jeff.King. All rights reserved.
//

#import "PickupColorViewController.h"

@interface PickupColorViewController ()

@end

@implementation PickupColorViewController
@synthesize colorsArray;
@synthesize colorsPickView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.colorsArray = [NSArray arrayWithObjects:[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor],[UIColor purpleColor],nil];
        self.colorsPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 240, self.view.frame.size.width, self.view.frame.size.height-40)];
        self.colorsPickView.dataSource = self;
        self.colorsPickView.delegate = self;
        [self.view addSubview:self.colorsPickView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.colorsArray count];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 70;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGFloat width = [self pickerView:pickerView widthForComponent:component];
    CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
    UIView *myView = [[UIView alloc] init];
    myView.frame = CGRectMake(0, 0, width, height);
    UILabel *labelOnComponent = [[UILabel alloc] init];
    labelOnComponent.frame = myView.frame;
    labelOnComponent.tag = 200;
    labelOnComponent.backgroundColor = [self.colorsArray objectAtIndex:row];
    [myView addSubview:labelOnComponent];
    return myView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int rowOfComponent0 = [pickerView selectedRowInComponent:0];
    int rowOfComponent1 = [pickerView selectedRowInComponent:1];
    int rowOfComponent2 = [pickerView selectedRowInComponent:2];
    
    UIView *viewOfComponent0 = (UILabel *)[pickerView viewForRow:rowOfComponent0 forComponent:0];
    UIView *viewOfComponent1 = (UILabel *)[pickerView viewForRow:rowOfComponent1 forComponent:1];
    UIView *viewOfComponent2 = (UILabel *)[pickerView viewForRow:rowOfComponent2 forComponent:2];
    
    UILabel *labelOnView0 = (UILabel *)[viewOfComponent0 viewWithTag:200];
    UILabel *labelOnView1 = (UILabel *)[viewOfComponent1 viewWithTag:200];
    UILabel *labelOnView2 = (UILabel *)[viewOfComponent2 viewWithTag:200];
    NSLog(@"R,G,B: %@, %@, %@",[labelOnView0 backgroundColor],[labelOnView1 backgroundColor],[labelOnView2 backgroundColor]);
}
@end