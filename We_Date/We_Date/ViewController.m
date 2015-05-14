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
    
    //创建live2d
    NSString *paths = [NSString stringWithFormat:@"live2d/%@/%@.model.json",@"shizuku",@"shizuku"];
    NSArray *array = [NSArray arrayWithObjects:paths, nil];
    DELive2dViewController *live2d = [[DELive2dViewController alloc] initWithModelsArray:[NSArray arrayWithObjects:array, nil]];
    [self addChildViewController:live2d];
    [self.view addSubview:live2d.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
