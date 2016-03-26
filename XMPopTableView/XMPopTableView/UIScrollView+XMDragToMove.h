//
//  UIScrollView+XMDragToMove.h
//  XMPopTableView
//
//  Created by zlm on 16/3/21.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMObject;

@interface UIScrollView (XMDragToMove)

@property (nonatomic, strong, readonly) XMObject *xmObject;
@property (nonatomic, assign) BOOL dragToDown;
@property (nonatomic, assign) CGRect openFrame;
@property (nonatomic, assign) CGRect closeFrame;

@end

@interface XMObject : NSObject

@end