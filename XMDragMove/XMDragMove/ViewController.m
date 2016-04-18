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
@property (nonatomic, assign) BOOL isShowTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableview = [[[NSBundle mainBundle] loadNibNamed:@"XMTableView" owner:nil options:nil] lastObject];
    self.tableview.array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    self.tableview.dragToDown = YES;
    self.tableview.closeRate = 0.1;
    self.tableview.xmDelegate = self;
    self.tableview.height = 300;
    [self.view addSubview:self.tableview];
    self.isShowTableView = NO;
}

- (IBAction)action:(id)sender {
    if (!self.isShowTableView) {
        [self.tableview popTableView];
    } else {
        [self.tableview hideTableView];
    }
}

- (void)popXMTableView
{
    NSLog(@"has popMenu");
    self.isShowTableView = YES;;
}

- (void)hideXMTableView
{
    NSLog(@"has closeMenu");
    self.isShowTableView = NO;
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
