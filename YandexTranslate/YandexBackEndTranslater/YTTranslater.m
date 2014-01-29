//
//  YTTranslater.m
//  YandexTranslate
//
//  Created by Zabolotnyy Sergey on 10/25/12.
//  Copyright (c) 2012 Zabolotnyy Sergey. All rights reserved.
//

#import "YTTranslater.h"
#import "AFNetworking.h"

#define BASE_URL @"https://translate.yandex.net/api/v1.5/tr.json"
#define API_KEY @""

#define RU @"ru"
#define EN @"en"
#define PL @"pl"
#define UK @"uk"
#define DE @"de"
#define TR @"tr"

@implementation YTTranslater

@synthesize delegate;

#pragma mark - Private methods

- (void)perfomRequest:(NSURLRequest *)requestURL
  withCompletionBlock:(void (^)(id response)) completionBlock
            failBlock:(void (^)(NSError *error)) failBlock
{
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil]];
    AFJSONRequestOperation *requestOperation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:requestURL
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:JSON];
         
         if (((NSString *)[responseDictionary objectForKey:@"code"]).intValue == 200)
         {
             if ( completionBlock )
                 completionBlock(responseDictionary);
         }
         else
         {
             NSError* error = [NSError errorWithDomain:@"YANDEXTranslater"
                                                  code:((NSString *)[responseDictionary objectForKey:@"code"]).intValue
                                              userInfo:
                               [NSDictionary dictionaryWithObject:[responseDictionary objectForKey:@"error"]
                                                           forKey:NSLocalizedDescriptionKey]];
             if(failBlock)
                 failBlock(error);
         }
     }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         if(failBlock)
             failBlock(error);
     }];
    
    [requestOperation start];
}

- (void)startRequestWithUrlString:(NSString *) urlString
              withCompletionBlock:(void (^)(NSDictionary* response)) completionBlock
                    withFailBlock:(void (^)(NSError* error)) failBlock

{
    NSAssert(API_KEY.length != 0, @"get api key");
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&key=%@",API_KEY]];
    NSString *stringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    
    [self perfomRequest:requestURL
    withCompletionBlock:^(NSDictionary *response)
     {
         if ( completionBlock )
             completionBlock(response);
     }
              failBlock:^(NSError *error)
     {
         if(failBlock)
             failBlock(error);
     }];
}

- (NSString *)prepareTextForWeb:(NSString *)text
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"( )"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSString *newText = [regex stringByReplacingMatchesInString:text
                                                        options:0
                                                          range:NSMakeRange(0, text.length)
                                                   withTemplate:@"+"];
    
    return newText;
}

#pragma mark - Public methods

- (NSString*)stringForTranslateDirection:(YTTranslateDirection)direction
{
    NSString *resourseLangString = nil;
    
    switch (direction)
    {
        case en:
            resourseLangString = EN;
            break;
            
        case de:
            resourseLangString = DE;
            break;
            
        case pl:
            resourseLangString = PL;
            break;
            
        case ru:
            resourseLangString = RU;
            break;
            
        case tr:
            resourseLangString = TR;
            break;
            
        case uk:
            resourseLangString = UK;
            break;
        default:
            break;
    }

    return resourseLangString;
}

- (YTTranslateDirection)translateDirectionForString:(NSString *)direction
{
    if ([direction isEqualToString:EN])
        return en;
    else if([direction isEqualToString:RU])
        return ru;
    else if([direction isEqualToString:DE])
        return de;
    else if([direction isEqualToString:PL])
        return pl;
    else if([direction isEqualToString:TR])
        return tr;
    else if([direction isEqualToString:UK])
        return uk;

    return -1;
}


- (void)detectLangForText:(NSString*)text
{
    if (text.length == 0)return;
    
    NSString *urlString = [NSString stringWithFormat:BASE_URL@"/detect?text=%@",[self prepareTextForWeb:text]];
    
    [self startRequestWithUrlString:urlString
                withCompletionBlock:^(NSDictionary *response)
     {
         NSLog(@"%@",response);
         if (delegate && [delegate respondsToSelector:@selector(detectedLanguage:)])
         {
             [delegate detectedLanguage:[self translateDirectionForString:[response objectForKey:@"lang"]]];
         }
     }
                      withFailBlock:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)translateText:(NSString*)text fromLang:(YTTranslateDirection)resourseLang toLang:(YTTranslateDirection)translateLang
{
    if (text.length == 0)return;
    
    NSString *urlString = [NSString stringWithFormat:BASE_URL@"/translate?lang=%@-%@&text=%@",[self stringForTranslateDirection:resourseLang],[self stringForTranslateDirection:translateLang],[self prepareTextForWeb:text]];
    
    [self startRequestWithUrlString:urlString
                withCompletionBlock:^(NSDictionary *response)
     {
         NSLog(@"%@",response);

         if (delegate && [delegate respondsToSelector:@selector(translatedText:)])
         {
             NSString *translatedText = @"";
             
             for (NSString *text in [response objectForKey:@"text"])
             {
                 translatedText = [NSString stringWithFormat:@"%@ %@ ",translatedText, text];
             }

             [delegate translatedText:translatedText];
         }

     }
                      withFailBlock:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

@end



