//
//  Request.h
//  SiSi
//
//  Created by Singular on 06.09.12.
//  Copyright (c) 2012 innomos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TProgressBlock)(uint64_t size, uint64_t total);

@interface CRequest : NSMutableURLRequest
{
    bool                    fDone;
    NSMutableData*          fReceivedData;
//    NSData*                 fCachedData;
    uint64_t                fStartTime;
    uint64_t                fResponseTime;
    int                     fStatus;
    bool                    fCanceled;
}

@property (strong, readonly) NSData*                    Data;
@property (strong) id                                   PostProcess;
@property (nonatomic, readonly, retain) NSError*        Error;
@property (nonatomic, readonly, retain) NSURLResponse*  URLResponse;
@property (assign)                      BOOL            Canceled;
//@property (nonatomic, readonly)         BOOL            DataRetrievedFromCache;
//@property (nonatomic, readonly)			BOOL			FileMode;
@property (nonatomic, copy)             TProgressBlock  ProgressBlock;

-(void)    start;
@end
