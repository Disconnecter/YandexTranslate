//
//  YTTranslater.h
//  YandexTranslate
//
//  Created by Zabolotnyy Sergey on 10/25/12.
//  Copyright (c) 2012 Zabolotnyy Sergey. All rights reserved.
//

typedef enum
{
    ru,
    en,
    pl,
    uk,
    de,
    tr

}YTTranslateDirection;

typedef enum
{
    ERR_TEXT_TOO_LONG,
    ERR_UNPROCESSABLE_TEXT,
    ERR_LANG_NOT_SUPPORTED 
}YTErorrType;

@protocol YTTranslaterDelegate;

@interface YTTranslater : NSObject

@property (assign, nonatomic) id<YTTranslaterDelegate>delegate;

- (void)detectLangForText:(NSString*)text;
- (NSString*)stringForTranslateDirection:(YTTranslateDirection)direction;
- (YTTranslateDirection)translateDirectionForString:(NSString *)direction;
- (void)translateText:(NSString*)text fromLang:(YTTranslateDirection)resourseLang toLang:(YTTranslateDirection)translateLang;

@end

@protocol YTTranslaterDelegate <NSObject>

@optional

- (void)detectedLanguage:(YTTranslateDirection)direction;
- (void)reciveError:(NSError*)error;
- (void)translatedText:(NSString*)text;

@end