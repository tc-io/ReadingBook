//
//  CellLevel1.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-23.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellLevel1 : UITableViewCell

@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;

@end
