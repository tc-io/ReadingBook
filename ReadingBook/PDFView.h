//
//  PDFViewer.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-7.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView
{
    // PDF 文档所有信息
    CGPDFDocumentRef pdf;
    // PDF 文档中的一页
    CGPDFPageRef page;
    // 总共页数
    int totalPages;
    // 当前页面
    int currentPage;
}

// 当前视图初始化类，在该方法中会创建CGPDFDocumentRef对象，传递PDF文件的名字和所需页面的大小
- (id)initWithFrame:(CGRect)frame filePath:(NSString *)fPath;
// 创建一个PDF对象，此方法在初始化类中被调用
- (CGPDFDocumentRef)createPDFWithFilePath:(NSString *)aFilePath;

- (void)reloadView;

// 页面之间跳转
- (void)goUpPage;
- (void)goDownPage;
- (void)jumpToPageByNumber:(int)gotoNumber;

@end
