//
//  YTAppDelegate.h
//  YandexTranslate
//
//  Created by Zabolotnyy Sergey on 10/25/12.
//  Copyright (c) 2012 Zabolotnyy Sergey. All rights reserved.
//

@class YTViewController;
@class YTTranslater;

@interface YTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YTViewController *viewController;
@property (retain, nonatomic) YTTranslater *translater;

+ (YTAppDelegate*)sharedInstance;
+ (YTTranslater*)translater;

@end
