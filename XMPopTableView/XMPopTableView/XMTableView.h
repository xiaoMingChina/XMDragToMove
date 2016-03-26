//
//  XMTableView.h
//  XMPopTableView
//
//  Created by zlm on 16/3/15.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMTableViewDelegate<NSObject>

- (void)XMPopViewDidScroll:(CGFloat)offsetY;

@end

@interface XMTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *array;
@property (weak, nonatomic) id<XMTableViewDelegate>del;

@end
