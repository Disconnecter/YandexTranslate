//
//  YTViewController.m
//  YandexTranslate
//
//  Created by Zabolotnyy Sergey on 10/25/12.
//  Copyright (c) 2012 Zabolotnyy Sergey. All rights reserved.
//

#import "YTViewController.h"

@implementation YTViewController

#pragma mark - Deallocation

- (void)dealloc
{
    [_inputTextView release];
    [_outputTextView release];
    [_fromDirection release];
    [_toDirection release];

    [super dealloc];
}

#pragma mark - Manage View

- (void)viewDidUnload
{
    [self setInputTextView:nil];
    [self setOutputTextView:nil];
    [self setFromDirection:nil];
    [self setToDirection:nil];

    [super viewDidUnload];
}

- (void)viewDidLoad
{
    UIPickerView *langPicker = [[UIPickerView alloc] init];
    langPicker.showsSelectionIndicator = YES;
    langPicker.delegate = self;
    langPicker.dataSource = self;
    
    _fromDirection.inputView = langPicker;
    _toDirection.inputView = langPicker;
    
    [langPicker release];
}

#pragma mark - Buttons actions

- (IBAction)detectLanguagePressed:(UIButton *)sender
{
    [[YTAppDelegate translater] detectLangForText:_inputTextView.text];
}

- (IBAction)translatePressed:(UIButton *)sender
{
    [[YTAppDelegate translater] translateText:_inputTextView.text
                                     fromLang:[[YTAppDelegate translater] translateDirectionForString:_fromDirection.text]
                                       toLang:[[YTAppDelegate translater] translateDirectionForString:_toDirection.text]];

    [self resignFirstResponderForAllTextFields];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImageView *langImage = [[UIImageView alloc] initWithFrame:CGRectMake(128,3,64,64)];

    NSString *imageString = [NSString stringWithFormat:@"%@.png",[[YTAppDelegate translater] stringForTranslateDirection:row]];

    [langImage setImage:[UIImage imageNamed:imageString]];
    
    return [langImage autorelease];;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 70;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_toDirection isFirstResponder])
    {
        _toDirection.text = [[YTAppDelegate translater] stringForTranslateDirection:row];
    }
    else if ([_fromDirection isFirstResponder])
    {
        _fromDirection.text = [[YTAppDelegate translater] stringForTranslateDirection:row];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponderForAllTextFields];
}

#pragma mark - YandexTranslater delegate

- (void)detectedLanguage:(YTTranslateDirection)direction
{
    _fromDirection.text = [[YTAppDelegate translater] stringForTranslateDirection:direction];
}

- (void)translatedText:(NSString*)text
{
    _outputTextView.text = text;
}

#pragma mark - Private methods

- (void)resignFirstResponderForAllTextFields
{
    [_inputTextView resignFirstResponder];
    [_outputTextView resignFirstResponder];
    [_fromDirection resignFirstResponder];
    [_toDirection resignFirstResponder];
}

@end
