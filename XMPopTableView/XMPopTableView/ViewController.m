//
//  ViewController.m
//  XMPopTableView
//
//  Created by zlm on 16/3/15.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import "ViewController.h"
#import "XMPopView.h"
#import "Masonry.h"
#import "XMTableView.h"
#import "UIScrollView+XMDragToMove.h"

@interface ViewController () <XMPopViewDelegate,XMTableViewDelegate>
@property (nonatomic, strong) XMPopView *popview;
@property (nonatomic, strong) XMTableView *tableview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action:(UIButton *)sender {
    
    if (_tableview) {
//        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view).offset(220);
//            make.leading.equalTo(self.view);
//            make.trailing.equalTo(self.view);
//            make.height.mas_equalTo(220);
//        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_tableview mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.view);
//            }];
//            [UIView animateWithDuration:.25 animations:^{
//                [self.view layoutIfNeeded];
//            }];
//        });
        [_tableview setFrame:_tableview.closeFrame];
        
        [UIView animateWithDuration:.25 animations:^{
            [_tableview setFrame:_tableview.openFrame];
            [self.view layoutIfNeeded];
        }];

    } else {
    _tableview = [[[NSBundle mainBundle] loadNibNamed:@"XMTableView" owner:nil options:nil] lastObject];
    _tableview.array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    _tableview.del = self;
    _tableview.closeFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    _tableview.openFrame = CGRectMake(0, self.view.bounds.size.height - 220,  self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:_tableview];
        [_tableview setFrame:_tableview.closeFrame];
        
        [UIView animateWithDuration:.25 animations:^{
            [_tableview setFrame:_tableview.openFrame];
            [self.view layoutIfNeeded];
        }];

//    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(220);
//        make.leading.equalTo(self.view);
//        make.trailing.equalTo(self.view);
//        make.height.mas_equalTo(220);
//    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_tableview mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view);
//        }];
//                [UIView animateWithDuration:.25 animations:^{
//                    [self.view layoutIfNeeded];
//                }];
//    });

    }
    
//    if (_popview) {
//        return;
//    }
//    _popview = [[[NSBundle mainBundle] loadNibNamed:@"XMPopView" owner:nil options:nil] lastObject];
//    _popview.array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
//    _popview.delegate = self;
//    _popview.closeFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
//    _popview.openFrame = CGRectMake(0, self.view.bounds.size.height - 220,  self.view.bounds.size.width, self.view.bounds.size.width);
//    _popview.tbv.closeFrame = _popview.closeFrame;
//    _popview.tbv.openFrame = _popview.openFrame;
//
//    [self.view addSubview:_popview];
//    [_popview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(220);
//        make.leading.equalTo(self.view);
//        make.trailing.equalTo(self.view);
//        make.height.mas_equalTo(220);
//    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_popview mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view);
//        }];
//        [UIView animateWithDuration:.25 animations:^{
//            [self.view layoutIfNeeded];
//        }];
//    });

}

//- (void)XMPopViewDidScroll:(CGFloat)offsetY
//{
//    [_popview mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-offsetY);
//
//    }];
//    NSLog(@"framehaschange  --- offset:%f",offsetY);
//
////    [_tableview mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.bottom.equalTo(self.view).offset(-offsetY);
////    }];
////    NSLog(@"framehaschange  --- offset:%f",offsetY);
//}
//
//- (void)XMPopViewShouldRemove
//{
//    [_popview mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(220);
//    }];
//    [UIView animateWithDuration:.25 animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//    [_popview removeFromSuperview];
//        _popview = nil;
//    }];
//
//}

@end
