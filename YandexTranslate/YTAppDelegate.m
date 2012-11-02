//
//  YTAppDelegate.m
//  YandexTranslate
//
//  Created by Zabolotnyy Sergey on 10/25/12.
//  Copyright (c) 2012 Zabolotnyy Sergey. All rights reserved.
//

#import "YTAppDelegate.h"
#import "YTViewController.h"
#import "YTTranslater.h"


@implementation YTAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_translater release];
    
    [super dealloc];
}

+ (YTAppDelegate*)sharedInstance
{
    return (YTAppDelegate*)[UIApplication sharedApplication].delegate;
}

+ (YTTranslater*)translater
{
    return [YTAppDelegate sharedInstance].translater;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[YTViewController alloc] initWithNibName:@"YTViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    _translater = [YTTranslater new];
    _translater.delegate = _viewController;
    
    
    return YES;
}


@end
