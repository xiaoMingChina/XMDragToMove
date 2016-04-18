//
//  UIScrollView+XMDragToMove.m
//  XMPopTableView
//
//  Created by zlm on 16/3/21.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import "UIScrollView+XMPopTableView.h"
#import <objc/runtime.h>

@interface XMObject ()

@property (nonatomic, strong ) UIButton  *btnHideTableView;
@property (nonatomic, assign ) CGRect  openFrame;
@property (nonatomic, assign ) CGRect  closeFrame;
@property (nonatomic, assign ) CGFloat closeRate;
@property (nonatomic, assign ) CGFloat realoffsetY;
@property (nonatomic, assign ) CGFloat oldOffsetY;
@property (nonatomic, assign ) BOOL    dragToDown;
@property (nonatomic, assign ) BOOL    isObserving;
@property (nonatomic, assign ) BOOL    frameIsChanged;
@property (nonatomic, assign ) BOOL    isShowing;
@property (nonatomic, assign ) id<XMDragToMoveDelegate> xmDelegate;

@end

static char UIScrollViewDragToDown;

@implementation UIScrollView (XMPopTableView)

@dynamic dragToDown,closeFrame,openFrame,closeRate,xmDelegate,height;

- (void)setDragToDown:(BOOL)dragToDown
{
    if (dragToDown) {
        XMObject *object = [[XMObject alloc] init];
        object.realoffsetY = 0;
        object.oldOffsetY = 0;
        object.dragToDown = YES;
        object.isShowing = NO;
        self.xmObject = object;
        if (!self.xmObject.isObserving) {
            [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
            self.xmObject.isObserving = YES;
        }
    } else {
        if (self.xmObject.isObserving) {
            [self removeObserver:self forKeyPath:@"contentOffset"];
            [self removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
            self.xmObject.isObserving = NO;
        }
    }
    self.openFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 220, [UIScreen mainScreen].bounds.size.width, 220);
    self.closeFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 220);
    [self setFrame:self.closeFrame];
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
                [self checkShow];
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
        if (self.xmObject.xmDelegate && [self.xmObject.xmDelegate respondsToSelector:@selector(frameIsChanged)]) {
            [self.xmObject.xmDelegate frameIsChanged];
        }
        if (offsetY > 0) {
#ifdef DEBUG
//            NSLog(@"----upDrag----frameIsChanged");
#endif
            if (self.xmObject.xmDelegate && [self.xmObject.xmDelegate respondsToSelector:@selector(scrollUP)]) {
                [self.xmObject.xmDelegate scrollUP];
            }
            self.xmObject.realoffsetY = self.xmObject.realoffsetY + offsetY;
            if (self.xmObject.realoffsetY > 0) {
                self.xmObject.realoffsetY = 0;
                return;
            }
        } else if (offsetY < 0){
#ifdef DEBUG
//            NSLog(@"====downDrag====frameIsChanged");
#endif
            if (self.xmObject.xmDelegate && [self.xmObject.xmDelegate respondsToSelector:@selector(scrollDown)]) {
                [self.xmObject.xmDelegate scrollDown];
            }
            self.xmObject.realoffsetY += offsetY;
        }
        if (![self isDecelerating]) {
            CGRect old_rect = self.frame;
            old_rect.origin.y = old_rect.origin.y - offsetY;
            self.frame = old_rect;
            self.contentOffset = CGPointZero;
        }
    } else {
        if (offsetY > self.xmObject.oldOffsetY) {
#ifdef DEBUG
//            NSLog(@"----upDrag----");
#endif
            if (self.xmObject.xmDelegate && [self.xmObject.xmDelegate respondsToSelector:@selector(scrollUP)]) {
                [self.xmObject.xmDelegate scrollUP];
            }
            self.xmObject.oldOffsetY = offsetY;
        } else if (offsetY < self.xmObject.oldOffsetY){
#ifdef DEBUG
//            NSLog(@"====downDrag====");
#endif
            if (self.xmObject.xmDelegate && [self.xmObject.xmDelegate respondsToSelector:@selector(scrollDown)]) {
                [self.xmObject.xmDelegate scrollDown];
            }
            if (offsetY > 0) {
                return;
            }
            self.xmObject.oldOffsetY = 0;
            self.xmObject.realoffsetY += offsetY;
            if (![self isDecelerating]) {
                self.contentOffset  = CGPointZero;
            }
        }
    }
    if ([self isDecelerating]) {
        [self checkShow];
    }
}

#pragma mark - Private Methonds -

- (void)checkShow
{
    if (self.xmObject.realoffsetY < - CGRectGetHeight(self.frame) * self.xmObject.closeRate) {
        [self hideTableView];
    } else {
        [self popTableView];
    }
}

-(void)popTableView
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.xmObject.openFrame;
    } completion:^(BOOL finished) {
        self.xmObject.realoffsetY = 0;
        self.xmObject.oldOffsetY = 0;
    }];
    
    if (self.xmObject.xmDelegate && [self.xmObject.xmDelegate respondsToSelector:@selector(popXMTableView)]) {
        [self.xmObject.xmDelegate popXMTableView];
    }
    if (!self.xmObject.isShowing) {
        [self.xmObject.btnHideTableView addTarget:self action:@selector(hideTableView) forControlEvents:UIControlEventTouchUpInside];
        [self.superview insertSubview:self.xmObject.btnHideTableView belowSubview:self];
        self.xmObject.isShowing = YES;
    }
}

-(void)hideTableView
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.xmObject.closeFrame;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.xmObject.realoffsetY = 0;
        self.xmObject.oldOffsetY = 0;
    }];
    
    if (self.xmObject.xmDelegate && [self.xmObject.xmDelegate respondsToSelector:@selector(hideXMTableView)]) {
        [self.xmObject.xmDelegate hideXMTableView];
    }
    
    if (self.xmObject.isShowing) {
        [self.xmObject.btnHideTableView removeTarget:self action:@selector(hideTableView) forControlEvents:UIControlEventTouchUpInside];
        [self.xmObject.btnHideTableView removeFromSuperview];
        self.xmObject.isShowing = NO;
    }
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

- (void)setCloseRate:(CGFloat)closeRate
{
    self.xmObject.closeRate = closeRate;
}

- (void)setXmDelegate:(id<XMDragToMoveDelegate>)xmDelegate
{
    self.xmObject.xmDelegate = xmDelegate;
}

- (void)setHeight:(CGFloat)height
{
    self.openFrame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - height, [UIScreen mainScreen].bounds.size.width, height);
    self.closeFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, height);
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

- (CGFloat)closeRate
{
    if (!self.xmObject.closeRate) {
        self.xmObject.closeRate = 0.1;
    }
    return self.xmObject.closeRate;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

#pragma mark - Remove Observer -

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil) {
        if (self.xmObject.isObserving && self.dragToDown) {
            [self removeObserver:self forKeyPath:@"contentOffset"];
            [self removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
            self.xmObject.isObserving = NO;
        }
    }
}

- (void)dealloc
{
    if (self.xmObject.isObserving && self.dragToDown) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
        [self removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
        self.xmObject.isObserving = NO;
    }
}
@end

@implementation XMObject

- (UIButton *)btnHideTableView
{
    if (!_btnHideTableView) {
        _btnHideTableView = [[UIButton alloc] init];
        _btnHideTableView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.100];
        _btnHideTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_btnHideTableView setExclusiveTouch:YES];
    }
    return _btnHideTableView;
}

@end
