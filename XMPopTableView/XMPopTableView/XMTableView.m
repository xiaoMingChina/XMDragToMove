//
//  XMTableView.m
//  XMPopTableView
//
//  Created by zlm on 16/3/15.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import "XMTableView.h"
#import "UIScrollView+XMDragToMove.h"

@implementation XMTableView
- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    self.dragToDown = YES;
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

#pragma mark - UIScrollViewDelegate -

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewWillBeginDragging  --- offset:%f",offsetY);
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewWillEndDragging  --- offset:%f",offsetY);
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewDidEndDragging  --- offset:%f",offsetY);
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"scrollViewDidScroll  --- offset:%f",offsetY);
//    if (offsetY < 0) {
//        if (_del && [_del respondsToSelector:@selector(XMPopViewDidScroll:)]) {
//            [_del XMPopViewDidScroll:offsetY];
//            //                    self.tbv.contentInset = UIEdgeInsetsMake(offsetY / 2, 0, 0, 0);
//            //            CGSize size = self.tbv.contentSize;
//            //            size.height += offsetY;
//            //            self.tbv.contentSize = size;
//            ////            self.tbv.contentSize.height = self.tbv.contentSize.height +offsetY;
//            //                NSLog(@"---  %f   ----",self.tbv.contentSize.height);
//        }
//    }
    
    
}


@end
