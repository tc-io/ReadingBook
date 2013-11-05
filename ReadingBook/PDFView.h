//
//  PDFViewer.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-7.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView

@property CGPDFDocumentRef pdf;
@property CGPDFPageRef page;    // PDF 文档中的一页
@property int currentPageNumber;    // 当前页面

- (id)initWithFrame:(CGRect)frame;

// 创建一个PDF对象，此方法在初始化类中被调用
- (CGPDFDocumentRef)getPDFRefWithFilePath:(NSString *)fPath;

- (void)reloadView;

@end
