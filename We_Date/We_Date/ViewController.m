//
//  ViewController.m
//  We_Date
//
//  Created by 梁臣 on 15/5/14.
//  Copyright (c) 2015年 梁臣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    bgView.layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view addSubview:bgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
