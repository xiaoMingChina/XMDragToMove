//
//  UIScrollView+XMDragToMove.m
//  XMPopTableView
//
//  Created by zlm on 16/3/21.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import "UIScrollView+XMDragToMove.h"
#import <objc/runtime.h>

@interface XMObject ()

@property (nonatomic, assign ) BOOL    frameIsChanged;
@property (nonatomic, assign ) CGRect  openFrame;
@property (nonatomic, assign ) CGRect  closeFrame;
@property (nonatomic, assign ) CGFloat realoffsetY;
@property (nonatomic, assign ) CGFloat oldOffsetY;
@property (nonatomic, assign ) BOOL    dragToDown;

@end

static char UIScrollViewDragToDown;

@implementation UIScrollView (XMDragToMove)

@dynamic dragToDown,closeFrame,openFrame;

- (void)setDragToDown:(BOOL)dragToDown
{
    if (dragToDown) {
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
        XMObject *object = [[XMObject alloc] init];
        object.realoffsetY = 0;
        object.oldOffsetY = 0;
        object.dragToDown = YES;
        self.xmObject = object;
    } else {
        [self removeObserver:self forKeyPath:@"contentOffset"];

    }
}

- (BOOL)dragToDown
{
    return self.xmObject.dragToDown;
}

#pragma mark - Observing -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldPoint = [[change objectForKey:@"old"] CGPointValue];
        CGPoint newPoint = [[change objectForKey:@"new"] CGPointValue];
        if (oldPoint.y == newPoint.y) {
            return;
        }

        [self scrollViewDidScrollWithKVO:newPoint];
    }
    if ([keyPath isEqualToString:@"panGestureRecognizer.state"]) {
        UIGestureRecognizerState state = self.panGestureRecognizer.state;
        switch (state) {
            case UIGestureRecognizerStateBegan:
                break;
            case UIGestureRecognizerStateChanged:
                break;
            case UIGestureRecognizerStateEnded:
                if (self.xmObject.realoffsetY < - 100) {
                    [self closeMenu];
                } else {
                    [self openMenu];
                }
                break;
            default:
                break;
        }
    }
}

- (void)scrollViewDidScrollWithKVO:(CGPoint)contentOffset
{
    CGFloat offsetY = contentOffset.y;
    self.xmObject.frameIsChanged = self.xmObject.realoffsetY < 0 ? YES:NO;
    
    if (self.xmObject.frameIsChanged) {
        if (offsetY > 0) {
            NSLog(@"----upDrag----frameIsChanged");
            self.xmObject.realoffsetY = self.xmObject.realoffsetY + offsetY;
            if (self.xmObject.realoffsetY > 0) {
                self.xmObject.realoffsetY = 0;
                return;
            }
        } else {
            NSLog(@"====downDrag====frameIsChanged");
            self.xmObject.realoffsetY += offsetY;
        }
        CGRect old_rect = self.frame;
        old_rect.origin.y = old_rect.origin.y - offsetY;
        self.frame = old_rect;
        self.contentOffset = CGPointZero;
    } else {
        if (offsetY > self.xmObject.oldOffsetY) {
            NSLog(@"----upDrag----");
            self.xmObject.oldOffsetY = offsetY;
        } else if (offsetY < self.xmObject.oldOffsetY){
            NSLog(@"====downDrag====");
            if (offsetY > 0) {
                return;
            }
            self.xmObject.oldOffsetY = 0;
            self.xmObject.realoffsetY += offsetY;
            self.contentOffset  = CGPointZero;
        }
    }
}

#pragma mark - Private Methonds -
-(void)openMenu
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.xmObject.openFrame;
    } completion:^(BOOL finished) {
        self.xmObject.realoffsetY = 0;
        self.xmObject.oldOffsetY = 0;
    }];
}
-(void)closeMenu
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.xmObject.closeFrame;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.xmObject.realoffsetY = 0;
        self.xmObject.oldOffsetY = 0;
    }];
}


#pragma mark - Setters -
- (void)setXmObject:(XMObject *)xmObject
{
    [self willChangeValueForKey:@"XMUIScrollViewDragToDown"];
    objc_setAssociatedObject(self, &UIScrollViewDragToDown,
                             xmObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"XMUIScrollViewDragToDown"];
}

- (void)setCloseFrame:(CGRect)closeFrame
{
    self.xmObject.closeFrame = closeFrame;
}

- (void)setOpenFrame:(CGRect)openFrame
{
    self.xmObject.openFrame = openFrame;
}

#pragma mark - Getters -

- (XMObject *)xmObject
{
    return objc_getAssociatedObject(self, &UIScrollViewDragToDown);
}

- (CGRect)closeFrame
{
   return  self.xmObject.closeFrame;
}

- (CGRect)openFrame
{
   return self.xmObject.openFrame;
}

@end

@implementation XMObject

@end


