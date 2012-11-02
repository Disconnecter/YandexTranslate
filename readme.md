# Yandex Translate
Implementation of Yandex Translate service
 [Read more](http://api.yandex.ru/translate/doc/dg/concepts/api-overview.xml) 
Example
-------
 ```objectivec
 [[YTAppDelegate translater] translateText:_inputTextView.text
                                     fromLang:[[YTAppDelegate translater] translateDirectionForString:_fromDirection.text]
                                       toLang:[[YTAppDelegate translater] translateDirectionForString:_toDirection.text]];
```
