//
//  YTViewController.h
//  YandexTranslate
//
//  Created by Zabolotnyy Sergey on 10/25/12.
//  Copyright (c) 2012 Zabolotnyy Sergey. All rights reserved.
//
#import "YTTranslater.h"

@interface YTViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, YTTranslaterDelegate>

@property (retain, nonatomic) IBOutlet UITextView *inputTextView;
@property (retain, nonatomic) IBOutlet UITextView *outputTextView;
@property (retain, nonatomic) IBOutlet UITextField *fromDirection;
@property (retain, nonatomic) IBOutlet UITextField *toDirection;

@end
