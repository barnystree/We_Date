//
//  DELive2dViewController.m
//  Live2DSample
//
//  Created by yuan on 14-3-14.
//  Copyright (c) 2014年 kato. All rights reserved.
//

#import "DELive2dViewController.h"
#import "IPhoneUtil.h"
#import "LAppModel.h"
#import "LAppDefine.h"
#include "LAppLive2DManager.h"

#define CC_SAFE_DELETE(p)   if(p) { delete (p); (p) = NULL; }

@implementation DELive2dViewController
{
	LAppLive2DManager* live2DMgr;
}

-(id)initWithModelsArray:(NSArray*)array
{
    self = [super init];
    if (self) {
        self.modelsArray = [[NSArray alloc] initWithArray:array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //live2d
    live2DMgr = new LAppLive2DManager();
	
	CGRect screen = [IPhoneUtil getScreenRect];
    LAppView* view = live2DMgr->createView(screen,_modelsArray);
	
	live2DMgr->changeModel(0);
	
	[self.view addSubview:(UIView*)view];
	
}

-(void)changeModel:(int)modelCount
{
    live2DMgr->changeModel(modelCount);
}

- (void)viewWillAppear:(BOOL)animated
{
    if (LAppDefine::DEBUG_LOG) NSLog(@"viewWillAppear @ViewController");
	live2DMgr->onResume();
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (LAppDefine::DEBUG_LOG) NSLog(@"viewWillDisappear @ViewController");
    live2DMgr->onPause();
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    live2DMgr->releaseModel();
    live2DMgr->releaseView();
}

-(void)motion:(int)n withName:(int)name
{
    live2DMgr->motion(MOTION_GROUP_SCRIPT_MOTION, n, name);
}

-(void)expression:(int)n withName:(int)name
{
    live2DMgr->startExpress(n, name);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    if (LAppDefine::DEBUG_LOG) NSLog(@"viewDidUnload @ViewController");
    delete live2DMgr;
    live2DMgr=nil;
}


@end
