//
//  TiledPDFView.m
//  ReadingBook
//
//  Created by Jeff.King on 13-11-14.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TiledPDFView {
    CGPDFPageRef pdfPage;
    CGFloat myScale;
}


// Create a new TiledPDFView with the desired frame and scale.
- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale {
    self = [super initWithFrame:frame];
    if (self) {
        
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        /*
         levelsOfDetail and levelsOfDetailBias determine how the layer is rendered at different zoom levels. This only matters while the view is zooming, because once the the view is done zooming a new TiledPDFView is created at the correct size and scale.
         */
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 3;
        tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
        
        myScale = scale;
    }
    return self;
}


// The layer's class should be CATiledLayer.
+ (Class)layerClass {
    return [CATiledLayer class];
}


// Set the CGPDFPageRef for the view.
- (void)setPage:(CGPDFPageRef)newPage {
    CGPDFPageRelease(self->pdfPage);
    self->pdfPage = CGPDFPageRetain(newPage);
}


-(void)drawRect:(CGRect)r {
    /*
     UIView uses the existence of -drawRect: to determine if it should allow its CALayer to be invalidated, which would then lead to the layer creating a backing store and -drawLayer:inContext: being called.
     Implementing an empty -drawRect: method allows UIKit to continue to implement this logic, while doing the real drawing work inside of -drawLayer:inContext:.
     */
}


// Draw the CGPDFPageRef into the layer at the correct scale.
-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context {
    // Fill the background with white.
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, self.bounds);
    
    CGContextSaveGState(context);
    // Flip the context so that the PDF page is rendered right side up.
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
    CGContextScaleCTM(context, myScale, myScale);
    CGContextDrawPDFPage(context, pdfPage);
    CGContextRestoreGState(context);
}


// Clean up.
- (void)dealloc {
    CGPDFPageRelease(pdfPage);
}

@end
