//
//  XMPopView.h
//  XMPopTableView
//
//  Created by zlm on 16/3/15.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMPopViewDelegate<NSObject>

- (void)XMPopViewDidScroll:(CGFloat)offsetY;
- (void)XMPopViewShouldRemove;

@end


@interface XMPopView : UIView <UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *array;
@property (weak, nonatomic) IBOutlet UITableView *tbv;
@property (weak, nonatomic) id<XMPopViewDelegate>delegate;
@property (nonatomic,assign) CGRect openFrame;
@property (nonatomic,assign) CGRect closeFrame;
@property (nonatomic,assign) CGFloat beginY;
@property (nonatomic,assign) CGFloat offsetY;
@property (nonatomic,assign) CGFloat oldOffsetY;
@property (nonatomic,assign) CGFloat newOffsetY;
@property (nonatomic,assign) BOOL frameIsChanged;
@end
