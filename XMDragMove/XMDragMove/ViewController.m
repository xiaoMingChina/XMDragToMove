//
//  ViewController.m
//  XMDragMove
//
//  Created by zlm on 16/4/15.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import "ViewController.h"
#import "XMTableView.h"
#import "UIScrollView+XMDragToMove.h"

@interface ViewController ()<XMDragToMoveDelegate>

@property (nonatomic, strong) XMTableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableview = [[[NSBundle mainBundle] loadNibNamed:@"XMTableView" owner:nil options:nil] lastObject];
    self.tableview.array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    self.tableview.dragToDown = YES;
    self.tableview.closeFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 300);
    self.tableview.openFrame = CGRectMake(0, self.view.bounds.size.height - 300,  self.view.bounds.size.width, 300);
    self.tableview.closeRate = 0.1;
    [self.tableview setFrame:self.tableview.closeFrame];
    [self.view addSubview:self.tableview];
    self.tableview.xmDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action:(id)sender {
    [UIView animateWithDuration:.25 animations:^{
        [self.tableview setFrame:self.tableview.openFrame];
        [self.view layoutIfNeeded];
    }];
}

- (void)closeMenu
{
    NSLog(@"has closeMenu");
}

- (void)scrollUP
{
    NSLog(@"scrollUp~~");
}

- (void)scrollDown
{
    NSLog(@"scrollDown~~");
}

- (void)frameIsChanged
{
    NSLog(@"frameIsChanged");
}

@end
