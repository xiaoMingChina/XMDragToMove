//
//  XMPopView.m
//  XMPopTableView
//
//  Created by zlm on 16/3/15.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import "XMPopView.h"
#import "UIScrollView+XMDragToMove.h"

@implementation XMPopView

- (void)awakeFromNib {
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
    self.tbv.dragToDown = YES;
    if (self.tbv.dragToDown) {
        NSLog(@"11");
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
    cell.backgroundColor = [UIColor redColor];
    
    NSString *str = self.array[indexPath.row];
    cell.textLabel.text = str;
    
    return cell;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 30;
//}

#pragma mark - UIScrollViewDelegate -

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewWillBeginDragging  --- offset:%f",offsetY);
//    self.beginY = offsetY;
//    self.oldOffsetY = offsetY;
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewWillEndDragging  --- offset:%f",offsetY);
//
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewDidEndDragging  --- offset:%f",offsetY);
//    
//    if (self.offsetY < - 40) {
//        [self closeMenu];
//    } else {
//        [self openMenu];
//    }
//    
////    if (_delegate && [_delegate respondsToSelector:@selector(XMPopViewShouldRemove)] && self.offsetY < -20) {
////        [_delegate XMPopViewShouldRemove];
////    }
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewWillBeginDecelerating  --- offset:%f",offsetY);
//
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewDidEndDecelerating  --- offset:%f",offsetY);
//    if (self.offsetY < - 40) {
//        [self closeMenu];
//    } else {
//        [self openMenu];
//    }
//
//}
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    if (self.frameIsChanged) {
//        if (offsetY > self.oldOffsetY){
//            NSLog(@"----upDrag----frameIsChanged");
//            
//            if (_delegate && [_delegate respondsToSelector:@selector(XMPopViewDidScroll:)]){
//                self.offsetY = self.offsetY + offsetY - self.oldOffsetY;
//                if (self.offsetY > 0) {
//                    self.offsetY = 0;
//                    self.frameIsChanged = NO;
//                    return;
//                }
//                [_delegate XMPopViewDidScroll:self.offsetY];
//                self.oldOffsetY = 0;
//                self.frameIsChanged = YES;
//                scrollView.contentOffset = CGPointZero;
//            }
//        } else {
//            NSLog(@"====downDrag====frameIsChanged");
//            if (_delegate && [_delegate respondsToSelector:@selector(XMPopViewDidScroll:)]){
//                self.oldOffsetY = 0;
//                self.offsetY += offsetY;
//                [_delegate XMPopViewDidScroll:self.offsetY];
//                self.frameIsChanged = YES;
//                scrollView.contentOffset = CGPointZero;
//            }
//        }
//    } else {
//        if (offsetY > self.oldOffsetY) {
//            NSLog(@"----upDrag----");
//            self.oldOffsetY = offsetY;
//            } else {
//                NSLog(@"====downDrag====");
//                if (offsetY > 0) {
//                    return;
//                }
//                if (_delegate && [_delegate respondsToSelector:@selector(XMPopViewDidScroll:)]){
//                    self.oldOffsetY = 0;
//                    self.offsetY += offsetY;
//                   [_delegate XMPopViewDidScroll:self.offsetY];
//                    self.frameIsChanged = YES;
//                    scrollView.contentOffset = CGPointZero;
//                }
//            }
//    }
//
//
//
//}
#pragma mark - Gesture Recognizer
- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer
{
    if( ([recognizer state] == UIGestureRecognizerStateBegan) ||
       ([recognizer state] == UIGestureRecognizerStateChanged) )
    {
        CGPoint movement = [recognizer translationInView:self.superview];
        CGRect old_rect = self.frame;
        
       
        
        old_rect.origin.y = old_rect.origin.y + movement.y;
        if(old_rect.origin.y < self.openFrame.origin.y)
        {
            self.frame = self.openFrame;
        }
        else if(old_rect.origin.y > self.closeFrame.origin.y)
        {
            self.frame = self.closeFrame;
        }
        else
        {
            self.frame = old_rect;
        }
        
        [recognizer setTranslation:CGPointZero inView:self.superview];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        CGFloat halfPoint = (self.closeFrame.origin.y + self.openFrame.origin.y)/ 2;
        if(self.frame.origin.y > halfPoint)
        {
            [self closeMenu];
            
        }
        else
        {
            [self openMenu];
        }
    }

}
-(void)openMenu
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.frame = self.openFrame;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)closeMenu
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.frame = self.closeFrame;
        if (_delegate && [_delegate respondsToSelector:@selector(XMPopViewShouldRemove)]) {
                    [_delegate XMPopViewShouldRemove];
                }
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *temp = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint movement = [temp translationInView:self.superview];
        if (movement.y > 0) {
            self.tbv.scrollEnabled = NO;
            return YES;
        } else {
            self.tbv.scrollEnabled = YES;
            return NO;
        }
    }
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end
