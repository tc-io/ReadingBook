//
//  TiledPDFView.h
//  ReadingBook
//
//  Created by Jeff.King on 13-11-14.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TiledPDFView : UIView

- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;

@end
