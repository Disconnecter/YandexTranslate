//
//  Request.m
//  SiSi
//
//  Created by Singular on 06.09.12.
//  Copyright (c) 2012 innomos. All rights reserved.
//

#import "Request.h"
//#import "WebContentCache.h"
#import <objc/runtime.h>
#import <sys/xattr.h>
//#import "NSData+reallyMapped.h"
#include <mach/mach_time.h>
//#import "Database.h"
//#import "LoaderPostProcess.h"
//#import <CommonCrypto/CommonDigest.h>
//#import "XLog.h"

#ifdef DEBUG
#define LOG_LOADING
#endif

//#undef LOG_LOADING

#ifdef LOG_LOADING
static mach_timebase_info_data_t info = {0,0};
#endif
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CRequest ()
@property (nonatomic, readwrite, retain)	NSURLResponse*		URLResponse;
@property (nonatomic, readwrite, retain)	NSError*			Error;
@property (nonatomic, retain)				NSURLConnection*	Connection;
//@property (nonatomic, readwrite, readonly)	BOOL				DataRetrievedFromCache;
//@property (nonatomic, readwrite, assign)	BOOL				FileMode;
//@property (nonatomic, retain)				NSFileHandle*		temporaryFile;
//@property (nonatomic, retain)				NSString*			temporaryFilePath;

-(void) doRequest;
@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation CRequest
//@synthesize FileMode = fFileMode;
@synthesize URLResponse = fURLResponse;
@dynamic Canceled;
//@synthesize DataRetrievedFromCache = fDataRetrievedFromCache;
//@synthesize temporaryFile, temporaryFilePath;
//@synthesize Error = fError;

#pragma mark -

-(id)initWithURL:(NSURL*)URL cachePolicy:(NSURLRequestCachePolicy)CachePolicy timeoutInterval:(NSTimeInterval)TimeoutInterval
{
    self = [super initWithURL:URL cachePolicy:CachePolicy timeoutInterval:TimeoutInterval];
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-(void)encodeWithCoder:(NSCoder*)Coder
//{
//    [super encodeWithCoder:Coder];
//    //post process это только название класса
//    [Coder encodeObject: [self PostProcess] forKey: @"PostProcess"];
//}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-(id)initWithCoder:(NSCoder *)Decoder
//{
//    self = [super initWithCoder:Decoder];
//    if (self)
//    {
//        self.PostProcess = [Decoder decodeObjectForKey: @"PostProcess"];
//    }
//    return self;
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-(void) dealloc
//{
//    [self.temporaryFile closeFile];
//	if ([self.temporaryFilePath length] != 0)
//    {
//		NSError* err = nil;
//		[[NSFileManager defaultManager] removeItemAtPath:self.temporaryFilePath error:&err];
//		if (err != nil)
//        {
//			NSLog(@"Cannot delete temporary file: %@ %@", self.temporaryFilePath, err);
//		}
//	}
//    self.temporaryFile = nil;
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)setFileMode:(BOOL)aFileMode
//{
//	fFileMode = aFileMode;
//	
//	if (self.FileMode)
//    {
//		fReceivedData = nil;
//		NSString* newFilename = nil;
//		
//		const char* concat_str = [[[self URL] absoluteString] UTF8String];
//        unsigned char result[CC_MD5_DIGEST_LENGTH];
//        CC_MD5(concat_str, strlen(concat_str), result);
//        NSMutableString* hash = [NSMutableString string];
//        for (int i = 0; i < 16; i++)
//            [hash appendFormat:@"%02X", result[i]];
//        
//		if ([self.URLResponse.suggestedFilename length] != 0)
//        {
//			newFilename = [NSString stringWithFormat:@"%@.%@", hash,
//                           [self.URLResponse.suggestedFilename pathExtension]];
//		}
//		else
//        {
//			newFilename = [NSString stringWithFormat:@"%@.tmp", hash];
//		}
//		
//        self.temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:newFilename];
//		NSFileManager* fm = [NSFileManager defaultManager];
//        
//		if(![fm createFileAtPath:self.temporaryFilePath contents:nil attributes:nil])
//        {
//			NSLog(@"Error: cannot create file at %@", self.temporaryFilePath);
//			fFileMode = false;
//            fReceivedData = [NSMutableData data];
//            return;
//		}
//		
//		self.temporaryFile = [NSFileHandle fileHandleForWritingAtPath:self.temporaryFilePath];
//	}
//	else
//    {
//		fReceivedData = [NSMutableData data];
//	}
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSData*) Data
{
//    if (self.DataRetrievedFromCache)
//        return fCachedData;
//    else
        return fReceivedData;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCanceled:(BOOL)Value
{
    @synchronized (self)
    {
        if (Value != fCanceled)
        {
            fCanceled = Value;
            if (fCanceled)
            {
                [self.Connection cancel];
            }
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL) Canceled
{
    BOOL ret = false;
    @synchronized (self)
    {
        ret = fCanceled;
    }
    return ret;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-(NSString*) arcName
//{
//    NSString* str = [NSString stringWithFormat:@"%@ %f", [self URL], CFAbsoluteTimeGetCurrent()];
//    const char* c_str = [str UTF8String];
//    unsigned char hash[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(c_str, strlen(c_str), hash);
//    NSMutableString* str_hash = [NSMutableString string];
//    for (int i = 0; i < 16; i++)
//        [str_hash appendFormat:@"%02X", hash[i]];
//    [str_hash appendString:@".plist"];
//    return str_hash;
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
-(void) start
{
    [self doRequest];
//    if (!self.Error)
//    {
//        if (fStatus == 200)
//            if (self.PostProcess)
//                [self.PostProcess process:[self.URL absoluteString] data:self.Data];
//    }
//    else
//        if (self.PostProcess)
//            [self.PostProcess processError:[self.URL absoluteString] errStr:[self.Error localizedDescription]];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) doRequest
{
    @autoreleasepool
    {
        fDone = false;
        self.Error = 0;
		
//        self.DataRetrievedFromCache = false;
        @try
        {
//            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:self];
//            if (self.cachePolicy == NSURLRequestReturnCacheDataElseLoad ||
//                self.cachePolicy == NSURLRequestReturnCacheDataDontLoad)
//            {
//                NSURLResponse* cached_response = 0;
//                fCachedData = [[CWebContentCache instance] cachedDataForRequest:self response:&cached_response];
//                if (fCachedData)
//                {
//                    self.URLResponse = cached_response;
//                    self.DataRetrievedFromCache = true;
//                    NSHTTPURLResponse* http_response = (NSHTTPURLResponse*)cached_response;
//                    NSString* etag = [[http_response allHeaderFields] valueForKey:@"Etag"];
//                    if (etag)
//                    {
//                        [self addValue:etag forHTTPHeaderField:@"If-None-Match"];
//                    }
//                }
//            }
            //if ([fReceivedData length] == 0 && [self.URLRequest cachePolicy] != NSURLRequestReturnCacheDataDontLoad)
            {
                self.Connection = [[NSURLConnection alloc] initWithRequest:self
                                                                  delegate:self
                                                          startImmediately:false];
                [self.Connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
#ifdef LOG_LOADING
                fStartTime = mach_absolute_time();
                printf("Loader: %s ", [[self.URL absoluteString] UTF8String]);
                if (info.denom == 0)
                    (void) mach_timebase_info(&info);
#endif
                [self.Connection start];
                NSPort* port = [NSMachPort port];
                [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];
                
                while (!fDone && !self.Canceled)
                {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.3f]];
                }
                
                [[NSRunLoop currentRunLoop] removePort:port forMode:NSDefaultRunLoopMode];
                [self.Connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                self.Connection = 0;
//#ifdef DEBUG
//                if (self.Canceled)
//                {
//                    DebugLog(@"cancel %@", self);
//                }
//#endif
            }
        }
        @catch (NSException* exception)
        {
//            DebugLog(@"%s, %s", [[exception name] UTF8String], [[exception reason] UTF8String]);
//            DebugLog(@"%@", [exception callStackSymbols]);
        }
        @finally
        {
            if (!self.Error)
            {
                //http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
                if (fStatus >= 400)
                {
                    NSString* loc_str = [NSHTTPURLResponse localizedStringForStatusCode:fStatus];
                    NSDictionary* user_info = [NSDictionary dictionaryWithObjectsAndKeys:loc_str, NSLocalizedDescriptionKey, nil];
                    self.Error = [NSError errorWithDomain:@"ContentCache.ErrorDomain"
                                                     code:fStatus
                                                 userInfo:user_info];
                }
            }
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - connection delegate
-(void) connection:(NSURLConnection*)Connection didReceiveResponse:(NSURLResponse*)Response
{
    
    NSHTTPURLResponse* http_response = (NSHTTPURLResponse*)Response;
    fStatus = [http_response statusCode];
//    self.FileMode = (Response.expectedContentLength > 300 * 1024);
#ifdef LOG_LOADING
    fResponseTime = mach_absolute_time();
    const uint64_t response_elapsed_MTU = fResponseTime - fStartTime;
    const double response_elapsed =  1e-6 * (double)response_elapsed_MTU * (double)info.numer / (double)info.denom;
    printf("status %d (%g ms ", fStatus, response_elapsed);
#endif
    if (fStatus == 200)
    {
        self.URLResponse = Response;
//        fCachedData = 0;
//        self.DataRetrievedFromCache = false;
        self.URLResponse = Response;
    }
//    if (fStatus == 304)
//    {
//        if (self.ProgressBlock)
//        {
//            self.ProgressBlock([fCachedData length], [self.URLResponse expectedContentLength]);
//        }
//    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)connection:(NSURLConnection*)Connection didReceiveData:(NSData*)AData
{
//	if (self.FileMode)
//    {
//		[self.temporaryFile writeData:AData];
//	}
//	else
//    {
        [fReceivedData appendData:AData];
//	}
    if (self.ProgressBlock)
    {
        self.ProgressBlock([AData length], [self.URLResponse expectedContentLength]);
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)connectionDidFinishLoading:(NSURLConnection*)Connection
{
    //if ([self.URLRequest cachePolicy] == NSURLRequestReloadIgnoringLocalCacheData)
    //    DebugLog(@"%@, data size %d", self.URLRequest, [fReceivedData length]);
    fDone = true;
    
    //    if (self.DataRetrievedFromCache)
    //        return;
//    if (fStatus == 200)
//    {
//        if ([self cachePolicy] == NSURLRequestReturnCacheDataElseLoad ||
//            [self cachePolicy] == NSURLRequestReloadIgnoringLocalCacheData)
//        {
//            if (self.FileMode)
//            {
//                [[CWebContentCache instance] storeResponse:self.URLResponse request:self file:temporaryFilePath];
//                NSURLResponse* cached_response = 0;
//                fReceivedData = (NSMutableData*)[[CWebContentCache instance] cachedDataForRequest:self response:&cached_response];
//            }
//            else
//                [[CWebContentCache instance] storeResponse:self.URLResponse request:self data:self.Data];
//            
//        }
//        else
//            if (self.FileMode)
//                fReceivedData = (NSMutableData*)[NSData dataWithContentsOfReallyMappedFile:temporaryFilePath];
//    }
    
#ifdef LOG_LOADING
    const uint64_t end_time = mach_absolute_time();
    const uint64_t conn_elapsed_MTU = end_time - fStartTime;
    const double conn_elapsed =  1e-6 * (double)conn_elapsed_MTU * (double)info.numer / (double)info.denom;
    uint d = [self.Data length];
    printf("%g ms) %d bytes\n", conn_elapsed, d);
#endif
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)connection:(NSURLConnection *)Connection didFailWithError:(NSError *)Err
{
#ifdef DEBUG
    printf("error\n");
#endif
    self.Error = Err;
//    if (!fDataRetrievedFromCache)
//    {
        fReceivedData = 0;
//        fCachedData = 0;
//    }
    fDone = true;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSCachedURLResponse *)connection:(NSURLConnection *)Connection willCacheResponse:(NSCachedURLResponse *)CachedResponse
{
    return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
