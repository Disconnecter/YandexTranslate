# Yandex Translate
Implementation of Yandex Translate service
 [Read more](http://api.yandex.ru/translate/doc/dg/concepts/api-overview.xml) 
 
[Get api key](http://api.yandex.ru/key/getkey.xml)

 For work define API_KEY value in YTTranslater.m file

Example
-------
 ```objectivec
 [[YTAppDelegate translater] translateText:_inputTextView.text
                                     fromLang:[[YTAppDelegate translater] translateDirectionForString:_fromDirection.text]
                                       toLang:[[YTAppDelegate translater] translateDirectionForString:_toDirection.text]];
```

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Disconnecter/yandextranslate/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
