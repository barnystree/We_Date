//
//  DELive2dViewController.h
//  Live2DSample
//
//  Created by yuan on 14-3-14.
//  Copyright (c) 2014年 kato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DELive2dViewController : UIViewController

-(id)initWithModelsArray:(NSArray*)array;

@property (nonatomic,strong) NSArray *modelsArray;

-(void)changeModel:(int)modelCount;
-(void)motion:(int)n  withName:(int)name;
-(void)expression:(int)n  withName:(int)name;

@end
