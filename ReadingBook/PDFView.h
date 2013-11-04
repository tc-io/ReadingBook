//
//  PDFViewer.h
//  ReadingBook
//
//  Created by Jeff.King on 13-10-7.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView

@property CGPDFDocumentRef pdf;    // PDF 文档所有信息
@property CGPDFPageRef page;    // PDF 文档中的一页
@property int currentPageNumber;    // 当前页面
@property (strong, nonatomic) NSString* filePath;

- (id)initWithFrame:(CGRect)frame :(NSString *)fPath :(int)curPageNum;

// 创建一个PDF对象，此方法在初始化类中被调用
- (CGPDFDocumentRef)getPDFRefWithFilePath:(NSString *)fPath;

- (void)reloadView;

// 页面之间跳转
//- (void)goUpPage;
//- (void)goDownPage;
//- (void)jumpToPageByNumber:(int)gotoNumber;


@end
