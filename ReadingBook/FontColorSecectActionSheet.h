//
//  FontColorSecectActionSheet.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-13.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomActionSheet : UIActionSheet

@property(nonatomic,retain)UIView* view;
@property(nonatomic,retain)UIToolbar* toolBar;


/*因为是通过给ActionSheet 加 Button来改变ActionSheet, 所以大小要与actionsheet的button数有关
 *height = 84, 134, 184, 234, 284, 334, 384, 434, 484
 *如果要用self.view = anotherview.  那么another的大小也必须与view的大小一样
 */

-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title;

@end