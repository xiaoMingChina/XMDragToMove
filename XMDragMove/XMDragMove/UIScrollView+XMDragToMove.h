//
//  UIScrollView+XMDragToMove.h
//  XMPopTableView
//
//  Created by zlm on 16/3/21.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMObject;

@protocol XMDragToMoveDelegate <NSObject>

- (void)closeMenu;
- (void)scrollUP;
- (void)scrollDown;
- (void)frameIsChanged;

@end


@interface UIScrollView (XMDragToMove)

@property (nonatomic, strong, readonly) XMObject *xmObject;
@property (nonatomic, assign) BOOL dragToDown;
@property (nonatomic, assign) CGRect openFrame;
@property (nonatomic, assign) CGRect closeFrame;
@property (nonatomic, assign) CGFloat closeRate;   //if offset greater it when scroll stop moving, will close menu. default is 0.1
@property (nonatomic, assign) id<XMDragToMoveDelegate> xmDelegate;

@end

@interface XMObject : NSObject

@end