//
//  XMTableView.m
//  XMPopTableView
//
//  Created by zlm on 16/3/15.
//  Copyright © 2016年 zlm. All rights reserved.
//

#import "XMTableView.h"

@implementation XMTableView
- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    cell.backgroundColor = [UIColor redColor];
    
    NSString *str = self.array[indexPath.row];
    cell.textLabel.text = str;
    
    return cell;
}

@end
